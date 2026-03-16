---
name: track
description: Compose a trade tweet for @MangroveTrader
---

Help the user compose a trade to tweet at @MangroveTrader.

## Steps

1. Ask what they want to trade: action (long/short/exit), quantity, symbol, price
2. For options: also need strike, C/P, expiry (YYYY-MM-DD)
3. Compose the tweet in the correct format:
   - Equities: `enter long 100 AAPL @ 185.50`
   - Crypto: `enter long 2.5 BTC @ 64000`
   - Futures: `enter short 5 ES @ 5250`
   - Options: `enter long 10 AAPL 190C 2026-04-18 @ 3.50`
4. Tell the user to tweet it to @MangroveTrader
