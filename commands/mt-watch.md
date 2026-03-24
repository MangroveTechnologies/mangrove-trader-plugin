---
name: mt-watch
description: Add a trader to your watchlist (activity notifications coming soon)
---

# mt-watch

Add a trader to your watchlist. This saves the relationship for future use -- activity notifications for watched traders are planned but not yet available.

## Steps

1. Ask for your Twitter handle if not known
2. Ask for the target trader's Twitter handle
3. Call the `trader_watch` MCP tool with `twitter_handle` (you) and `target_handle` (them)
4. If successful: show confirmation and current watch count
5. If `SELF_WATCH`: tell the user they can't watch themselves
6. If `NOT_A_TRADER`: tell the user they need to make a trade first via `/mt-track`
7. If `TRADER_NOT_FOUND`: the target doesn't exist, suggest `/mt-search` to find them
