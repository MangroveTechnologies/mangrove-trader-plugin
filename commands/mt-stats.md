---
name: mt-stats
description: Look up a trader's stats -- score, rank, trade count, and open positions (free)
---

# mt-stats

Look up a trader's stats on MangroveTrader.

## Steps

1. Ask for the Twitter handle if not provided (with or without @)
2. Call the `trader_my_stats` MCP tool with `twitter_handle`
3. Present results:
   - **Composite Score** (0-100)
   - **Rank** (among all traders, 0 = unranked)
   - **Total Trades**
   - **Qualified** (true/false -- minimum trade count required for leaderboard)
   - **Open Positions** count
4. If score is 0.0, note that scoring runs at midnight UTC daily
5. Suggest `/mt-report` for a detailed performance breakdown
