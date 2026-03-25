---
name: mt-help
description: Show all MangroveTrader plugin commands
---

# mt-help

Display all available MangroveTrader commands.

## Output

Present this to the user:

```
MangroveTrader — mangrovetraders.com

Getting started:
  1. /mt-set-handle <your_twitter_handle>   Set your identity
  2. /mt-track                              Compose and tweet a trade
  3. /mt-stats                              Check your score and rank

Commands:
  /mt-track                            Compose a trade tweet
  /mt-stats [handle]                   Score, rank, open positions
  /mt-report [handle] [timeframe]      Performance breakdown
  /mt-last [handle]                    Most recent trade
  /mt-history [handle] [limit]         Trade history (own free, others $0.01/3)
  /mt-leaderboard [timeframe] [limit]  Rankings ($0.25+, top 5 free on Twitter)
  /mt-search <query>                   Find a trader ($0.02)
  /mt-cancel [handle]                  Cancel last trade (5-min window)
  /mt-watch [handle] <target>          Watch a trader
  /mt-unwatch [handle] <target>        Unwatch a trader
  /mt-set-handle <handle>              Set your Twitter handle for this session
  /mt-status                           Server health
  /mt-help                             This help message

[handle] = optional if set via /mt-set-handle, <param> = required.
Trades submitted by tweeting @MangroveTrader. Paid tools use x402 (USDC on Base).
```
