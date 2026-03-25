---
name: mt-last
description: Show a trader's most recent trade and total trade count (free)
---

# mt-last

Show a trader's most recent trade.

## Steps

1. Use the handle from `/mt-set-handle` if set. Otherwise ask for Twitter handle.
2. Call the `trader_last_trade` MCP tool with `twitter_handle`
3. **If MCP tool is not available**, fall back to REST: `POST https://api.mangrovetraders.com/api/v1/trader/last_trade` with `{"twitter_handle": "<handle>"}`
4. Present the most recent trade:
   - **Action** (enter_long, enter_short, exit_long, exit_short)
   - **Symbol** and **Asset Class**
   - **Quantity** and **Price**
   - **Timestamp**
   - **Total trade count**
5. Mention that full trade history is available via `/mt-history` (free for your own, $0.01/3 trades for others)
