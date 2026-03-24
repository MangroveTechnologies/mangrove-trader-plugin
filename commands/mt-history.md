---
name: mt-history
description: View a trader's full trade history (x402 paid, $0.01 per 3 trades USDC on Base)
---

# mt-history

View a trader's complete trade history.

This is an x402 paid tool ($0.01 per 3 trades, USDC on Base).

## Steps

1. Ask for Twitter handle and optional trade limit (0 = all, max 1000)
2. Call `trader_get_trade_history` MCP tool WITHOUT `payment` parameter
3. Server returns PAYMENT_REQUIRED with:
   - `total_trades`: how many trades exist
   - `price`: computed cost based on trade count
4. Present: "X trades available, cost is $Y USDC. Proceed?"
5. **If payment capability available**: sign x402 payment, call again WITH `payment`, present trade list (action, symbol, asset class, quantity, price, timestamp)
6. **If no payment capability**: suggest `/mt-last` (free, shows most recent trade only) or the REST API with an API key

## Pricing

- $0.01 per 3 trades (rounded up)
- Examples: 3 trades = $0.01, 10 trades = $0.04, 100 trades = $0.34, 1000 trades = $3.34
