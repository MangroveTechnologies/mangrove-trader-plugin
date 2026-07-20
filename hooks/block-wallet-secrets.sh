#!/bin/bash
# block-wallet-secrets.sh — refuse to let EVM private keys or BIP39 mnemonics
# flow through Claude Code's conversation.
#
# Why this exists:
#   MangroveTrader's paid tools use x402 micropayments, which require an EVM
#   wallet key to sign. The safe way to provide that key is the
#   MT_WALLET_PRIVATE_KEY environment variable, set OUT-OF-BAND (shell profile
#   / MCP client env config) — never pasted into chat. Anything typed into the
#   conversation lands in the transcript (~/.claude/projects/**/*.jsonl on disk)
#   and is sent to the Anthropic API. This hook enforces "never paste keys"
#   structurally instead of relying on documentation alone.
#
# Usage:
#   block-wallet-secrets.sh --mode user   # UserPromptSubmit — strict match
#   block-wallet-secrets.sh --mode tool   # PostToolUse — context-aware match
#
# --mode user:
#   A 0x+64-hex private key or a real BIP39 mnemonic anywhere in the user's
#   message is blocked. User input doesn't contain tx hashes, so a bare
#   pattern match is safe and catches the common "user pasted their key" case.
#
# --mode tool:
#   Tool responses routinely contain 0x+64-hex tx hashes — a bare match would
#   block every trade lookup. So we block only when a key-shaped value sits
#   next to a key-naming field ("private_key", "secret", "mnemonic", ...).
#   This catches a server regression that leaks key material in a response
#   without false-positiving on tx hashes.
#
# Exit codes (Claude Code hook protocol): 0 allow · 2 block (stderr → model).
# Fail-open on tooling problems so it never wedges a turn for its own reasons.
# This is a plugin hook (travels with the install); do not disable it to route
# around a block — if the rule is wrong, change it in a PR.

set -uo pipefail

MODE=""
for arg in "$@"; do
    case "$arg" in
        --mode=user|--mode=tool) MODE="${arg#--mode=}" ;;
        --mode) shift; MODE="${1:-}" ;;
    esac
done
[ -z "$MODE" ] && MODE="user"

INPUT="$(cat 2>/dev/null)"

# EVM private-key-shaped string: 0x + exactly 64 hex chars, word-bounded.
EVM_KEY_RE='(^|[^0-9a-fA-F])0x[0-9a-fA-F]{64}([^0-9a-fA-F]|$)'

# Key-context field names (tool-mode only).
KEY_FIELD_RE='"(private_key|seed_phrase|secret|mnemonic|wallet_secret|master_key|MT_WALLET_PRIVATE_KEY)"[[:space:]]*:'

# BIP39 mnemonic detection: a run of >=12 consecutive words ALL from the
# 2048-word BIP39 list. Common English stopwords are NOT in the list, so real
# prose cannot sustain a 12-word run while a genuine seed phrase will.
# Fail-open (no mnemonic) if the wordlist is missing — the EVM-key check is
# independent and still fires.
WORDLIST="$(dirname "${BASH_SOURCE[0]}")/bip39-english.txt"

mnemonic_present() {
    MNEMONIC_TEXT="$1" WORDLIST="$WORDLIST" python3 - <<'PY' 2>/dev/null
import os, re, sys
try:
    words = {w.strip() for w in open(os.environ["WORDLIST"]) if w.strip()}
except Exception:
    sys.exit(1)
if not words:
    sys.exit(1)
toks = re.findall(r"[a-z]+", os.environ.get("MNEMONIC_TEXT", "").lower())
run = 0
for t in toks:
    run = run + 1 if t in words else 0
    if run >= 12:
        sys.exit(0)
sys.exit(1)
PY
}

HIT=""
if [ "$MODE" = "user" ]; then
    if printf '%s' "$INPUT" | grep -qE "$EVM_KEY_RE"; then
        HIT="evm_private_key"
    elif mnemonic_present "$INPUT"; then
        HIT="bip39_mnemonic"
    fi
else
    if printf '%s' "$INPUT" | grep -qE "$KEY_FIELD_RE"; then
        if printf '%s' "$INPUT" | grep -qE "$EVM_KEY_RE"; then
            HIT="evm_private_key_in_named_field"
        elif mnemonic_present "$INPUT"; then
            HIT="bip39_mnemonic_in_named_field"
        fi
    fi
fi

[ -z "$HIT" ] && exit 0

_HOOK_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)/$(basename "${BASH_SOURCE[0]}")"
cat >&2 <<EOF
BLOCKED by block-wallet-secrets.sh (mode=$MODE): detected a $HIT pattern in the
conversation. Wallet secrets MUST NOT flow through Claude Code's chat — they
would be written to your transcript (~/.claude/projects/**/*.jsonl) and sent to
the Anthropic API.

MangroveTrader signs x402 payments with the MT_WALLET_PRIVATE_KEY environment
variable, provided OUT-OF-BAND — never in chat. To set it up:

  1. Use a DEDICATED wallet funded with a small amount of USDC on Base
     (not your main wallet).
  2. Export the key in your shell profile or your MCP client's env config, e.g.
       export MT_WALLET_PRIVATE_KEY=0x...          # in ~/.zshrc / ~/.bashrc
     The x402 auto-pay hook reads it from the environment; it never needs to be
     typed into this conversation.
  3. Auto-pay is capped by MT_MAX_PAYMENT_USD (default \$0.30/request).

If this was a tool response that matched (defense-in-depth trip), inspect the
tool — responses must never carry plaintext key material.

If this was a false positive (not a real key/mnemonic), rephrase to avoid the
0x + 64-hex structure.

──────────────────────────────────────────────────────────────────────────
Guardrail: ${_HOOK_PATH}
This block is intentional. Do NOT modify or disable this hook to get around it.
If the rule itself is wrong, change it in a PR — don't route around it.
──────────────────────────────────────────────────────────────────────────
EOF
exit 2
