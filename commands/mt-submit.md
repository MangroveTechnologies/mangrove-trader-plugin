---
name: mt-submit
description: Submit a trade directly to MangroveTrader — no tweet required (3/day free, then $0.02)
---

# mt-submit

Enter or exit a position on MangroveTrader **directly** — no tweet to @MangroveTrader needed.

## Steps

1. Check the `MT_AUTH_TOKEN` environment variable. If set, use it as `auth_token`.
2. If `MT_AUTH_TOKEN` is not set, call `trader_login` to get a verification URL and stop — a verified X handle is required.
3. Collect the trade if not already provided:
   - **action**: `enter_long`, `enter_short`, `exit_long`, `exit_short` (shortcuts: long, short, sell, cover)
   - **symbol**: ticker (BTC, AAPL, ES, ...)
   - **price**: execution price — **required** for both entries and exits
   - **quantity**: units (default 1)
   - Options only: **strike_price**, **option_type** (`C`/`P`), **expiry_date** (`YYYY-MM-DD`)
4. Call the `trader_submit_trade` MCP tool with `auth_token` + the trade params.
5. **If the MCP tool is unavailable**, fall back to REST:
   `POST https://api.mangrovetraders.com/api/v1/trader/submit_trade` with the JSON body.
6. **Free tier:** the first 3 submissions/day are free — surface `free_trades_remaining_today`.
7. **Past the free tier:** the tool returns `PAYMENT_REQUIRED` at **$0.02 USDC (Base)**. If `MT_WALLET_PRIVATE_KEY` is set, the x402 auto-pay hook signs it automatically; otherwise present the price and payment requirement. **Never ask for a private key in chat** (the plugin hook blocks it).
8. Present the result: `status` (recorded), the position outcome (opened / averaged / closed / partial_exit), and remaining free trades.

## Notes
- Requires a verified X handle (via `trader_login`) — v1 keys the leaderboard on your Twitter handle.
- A rejected trade (e.g. exit with no open position) is **not** charged and does **not** count against your free tier.
- Prefer to log a trade via Twitter instead? Use `/mt-track` to compose the tweet.
