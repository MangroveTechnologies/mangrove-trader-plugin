---
name: mt-last
description: Show a trader's most recent trade and total trade count (free)
---

# mt-last

Show a trader's most recent trade.

## Steps

1. Ask for Twitter handle if not provided
2. Call the `trader_last_trade` MCP tool with `twitter_handle`
3. Present the most recent trade:
   - **Action** (enter_long, enter_short, exit_long, exit_short)
   - **Symbol** and **Asset Class**
   - **Quantity** and **Price**
   - **Timestamp**
   - **Total trade count**
4. Mention that full trade history is available via `/mt-history` (paid, $0.01 per 3 trades)
