# MangroveTrader Plugin for Claude Code

Social trading leaderboard plugin. Track trades via [@MangroveTrader](https://twitter.com/MangroveTrader) on Twitter, check your stats and performance for free, and access full rankings and trader search via x402 micropayments.

## Install

From source (GitHub):

```bash
git clone https://github.com/MangroveTechnologies/mangrove-trader-plugins.git
claude plugin marketplace add ./mangrove-trader-plugins
claude plugin install mangrove-trader
```

Or load for a single session without installing:

```bash
claude --plugin-dir ./mangrove-trader-plugins
```

## Tools

| Tool | Access | Price | Description |
|------|--------|-------|-------------|
| `trader_my_stats` | Free | -- | Your score, rank, and open positions |
| `trader_performance_report` | Free | -- | Detailed scoring breakdown (return, Sharpe, drawdown) |
| `trader_last_trade` | Free | -- | Most recent trade and total trade count |
| `trader_get_leaderboard` | Paid | $0.25+ USDC | Full leaderboard rankings (dynamic pricing) |
| `trader_search_trader` | Paid | $0.02 USDC | Look up any trader by handle or name |
| `trader_get_trade_history` | Paid | $0.01/3 trades | Complete trade log |

## Commands

| Command | Description |
|---------|-------------|
| `/mangrove-trader:status` | Check server health and list tools |
| `/mangrove-trader:track` | Compose a trade tweet |
| `/mangrove-trader:stats` | Quick stats lookup |

## How Trading Works

1. Tweet your trade to **@MangroveTrader** on Twitter
2. A Grok-powered agent parses your trade and tracks the position
3. Positions are marked-to-market against real prices every 5 minutes
4. Scoring runs daily: 50% return, 30% consistency (Sharpe), 20% risk management (max drawdown)

### Tweet Format

```
enter long 100 AAPL @ 185.50       # Equities
enter long 2.5 BTC @ 64000         # Crypto
enter short 5 ES @ 5250            # Futures
enter long 10 AAPL 190C 2026-04-18 @ 3.50  # Options
```

## x402 Payments

Paid tools use the [x402 protocol](https://www.x402.org/) for micropayments:

- **Network:** Base (Coinbase L2)
- **Currency:** USDC
- **Flow:** Call without payment -> see price -> confirm -> call with payment
- **Safety:** You are never charged if data retrieval fails

## Scoring

| Component | Weight | Metric |
|-----------|--------|--------|
| Return | 50% | Total return percentage |
| Consistency | 30% | Sharpe ratio |
| Risk Management | 20% | Max drawdown (lower is better) |

Traders must reach a minimum trade count to qualify for the leaderboard.

## License

MIT
