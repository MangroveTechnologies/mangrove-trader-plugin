---
name: mt-search
description: Search for a trader by handle or name (x402 paid, $0.02 USDC on Base)
---

# mt-search

Search for a trader on MangroveTrader.

This is an x402 paid tool ($0.02 USDC on Base).

## Steps

1. Ask for the search query -- Twitter handle or display name
2. Call `trader_search_trader` MCP tool WITHOUT the `payment` parameter, with `query`
3. Server returns PAYMENT_REQUIRED ($0.02 USDC)
4. Present the price and ask to confirm
5. **If payment capability available**: sign x402 payment, call again WITH `payment`, present results (handle, display name, score, rank, trade count, qualified status)
6. **If no payment capability**: suggest `/mt-stats <handle>` (free, if they know the exact handle)

## Parameters

- `query`: Search string -- handle or display name (max 100 chars)
- `limit`: 1-50 results (default: 20)
- `payment`: signed x402 payment header (from step 5)
