---
name: status
description: Check MangroveTrader server health and list available tools with pricing
---

Check the MangroveTrader server status and list all available tools.

## Steps

1. Call any free tool (e.g., `trader_my_stats` with handle `@MangroveTrader`) to verify the server is responding
2. Report the server status (connected/disconnected)
3. List all 6 tools with their access tier and pricing:

| Tool | Access | Price |
|------|--------|-------|
| `trader_my_stats` | Free | -- |
| `trader_performance_report` | Free | -- |
| `trader_last_trade` | Free | -- |
| `trader_get_leaderboard` | x402 | $0.25+ USDC |
| `trader_search_trader` | x402 | $0.02 USDC |
| `trader_get_trade_history` | x402 | $0.01/3 trades |

All x402 payments are in USDC on Base.
