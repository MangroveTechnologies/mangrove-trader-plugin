---
name: mt-unwatch
description: Remove a trader from your watchlist
---

# mt-unwatch

Remove a trader from your watchlist. See `/mt-watch` for details on what the watchlist does.

## Steps

1. Ask for your Twitter handle if not known
2. Ask for the target trader's Twitter handle
3. Call the `trader_unwatch` MCP tool with `twitter_handle` (you) and `target_handle` (them)
4. If successful: show confirmation
5. If `NOT_A_TRADER`: tell the user they need to make a trade first
6. If `TRADER_NOT_FOUND`: the target doesn't exist
