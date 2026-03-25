---
name: mt-stats
description: Look up a trader's stats -- score, rank, trade count, and open positions (free)
---

# mt-stats

Look up a trader's stats on MangroveTrader.

## Steps

1. Use the handle from `/mt-set-handle` if set. Otherwise ask for the Twitter handle (with or without @).
2. Call the `trader_my_stats` MCP tool with `twitter_handle`
3. **If MCP tool is not available**, fall back to REST: `POST https://api.mangrovetraders.com/api/v1/trader/my_stats` with `{"twitter_handle": "<handle>"}`
4. Present results:
   - **Composite Score** (0-100)
   - **Rank** (among all traders, 0 = unranked)
   - **Total Trades**
   - **Qualified** (true/false -- minimum trade count required for leaderboard)
   - **Open Positions** count
5. If score is 0.0, note that scoring runs at midnight UTC daily
6. Suggest `/mt-report` for a detailed performance breakdown
