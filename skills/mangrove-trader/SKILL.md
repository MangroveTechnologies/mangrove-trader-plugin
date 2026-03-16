---
name: mangrove-trader
description: >-
  Use when the user asks about trading, leaderboard, portfolio, performance,
  track a trade, log a buy or sell, check stats, rank, score, search for a
  trader, look up a trader, last trade, trade history, x402 payment, top
  traders, how am I doing, my rank, my score, my positions, open positions.
version: 1.0.0
---

# MangroveTrader

Social trading leaderboard. Traders tweet to **@MangroveTrader** on Twitter, a Grok-powered agent parses trades, tracks positions against real market data, computes scoring metrics, and exposes rankings.

**6 MCP tools** — 3 free, 3 paid via x402 micropayments (USDC on Base).

---

## Track a Trade

MangroveTrader tracks trades posted to Twitter. Help the user compose their trade tweet.

### Tweet Format

Tweet to **@MangroveTrader** with one of these formats:

| Asset Class | Example |
|-------------|---------|
| **Equities** | `enter long 100 AAPL @ 185.50` |
| **Crypto** | `enter long 2.5 BTC @ 64000` |
| **Futures** | `enter short 5 ES @ 5250` |
| **Options** | `enter long 10 AAPL 190C 2026-04-18 @ 3.50` |

**Actions:** `enter long`, `enter short`, `exit long`, `exit short`
**Shortcuts:** `long 100 AAPL` (defaults to `enter long`), `bought`, `sold`, `grabbed`, `dumped`, `faded`

### Steps

1. Ask for trade details if not provided: action, quantity, symbol, price
2. For options: also need strike, C/P (call/put), expiry (YYYY-MM-DD format)
3. Compose the tweet text
4. Tell the user: "Tweet this to @MangroveTrader:" followed by the formatted trade text

### Other Twitter Commands

- `my stats` — replies with score, rank, trade count
- `leaderboard` — replies with x402 payment requirements
- `cancel last` — cancels the most recent trade

---

## My Stats / Portfolio (Free)

**Tool:** `trader_my_stats`

### Steps

1. Ask for the user's Twitter handle if not known
2. Call `trader_my_stats` with `twitter_handle`
3. Present results:
   - **Composite Score** (0-100)
   - **Rank** (among all traders)
   - **Total Trades**
   - **Qualified** (true/false — requires minimum trade count)
   - **Open Positions** count
4. Suggest the performance skill for a detailed breakdown

---

## Performance Report (Free)

**Tool:** `trader_performance_report`

### Steps

1. Ask for Twitter handle and timeframe if not provided
2. Call `trader_performance_report` with `twitter_handle` and `timeframe`
   - Valid timeframes: `daily`, `weekly`, `monthly`, `all_time`, `30d`, `7d`
   - Default: `30d`
3. Present results with scoring breakdown:
   - **Composite Score** and **Rank**
   - **Return %** (50% of score weight)
   - **Sharpe Ratio** — consistency measure (30% of score weight)
   - **Max Drawdown %** — risk management (20% of score weight)
   - **Win Rate** and **Trade Count**

### Scoring Formula

| Component | Weight | Metric |
|-----------|--------|--------|
| Return | 50% | Total return percentage |
| Consistency | 30% | Sharpe ratio |
| Risk Management | 20% | Max drawdown (lower is better) |

---

## Last Trade (Free)

**Tool:** `trader_last_trade`

### Steps

1. Ask for Twitter handle if not known
2. Call `trader_last_trade` with `twitter_handle`
3. Present the most recent trade:
   - **Action** (buy/sell/long/short)
   - **Symbol**
   - **Quantity** and **Price**
   - **Timestamp**
   - **Total trade count**
4. Mention that full trade history is available via the paid `trader_get_trade_history` tool

---

## Leaderboard ($0.25+ USDC on Base)

**Tool:** `trader_get_leaderboard`

This is an x402 paid tool. Follow the [x402 Payment Flow](#x402-payment-flow) below.

### Steps

1. Call `trader_get_leaderboard` **WITHOUT** the `payment` parameter
   - Include `timeframe` and `limit` if the user specified them
   - Default: `timeframe="all_time"`, `limit=100`
2. Server returns `PAYMENT_REQUIRED` with the price
3. Tell the user the cost and ask to confirm
4. If confirmed, call again **WITH** the `payment` parameter from the response
5. Present the leaderboard: rank, handle, score, return %

### Parameters

- `timeframe`: `daily`, `weekly`, `monthly`, `all_time`, `30d`, `7d` (default: `all_time`)
- `limit`: 1-500 (default: 100)
- `payment`: x402 payment signature (from PAYMENT_REQUIRED response)

### Pricing

- **$0.25** for up to 100 rows
- **+$0.01 per 4 additional rows** beyond 100
- Max 500 rows
- Examples: 100 rows = $0.25, 200 rows = $0.50, 500 rows = $1.25

### If Declined

- Their own rank is always free via `trader_my_stats`
- Daily top 10 posted on @MangroveTrader Twitter

---

## Search Trader ($0.02 USDC on Base)

**Tool:** `trader_search_trader`

This is an x402 paid tool. Follow the [x402 Payment Flow](#x402-payment-flow) below.

### Steps

1. Get the Twitter handle or name to search for
2. Call `trader_search_trader` **WITHOUT** the `payment` parameter, with the `query`
3. Server returns `PAYMENT_REQUIRED` ($0.02 USDC)
4. Ask the user to confirm
5. If confirmed, call again **WITH** the `payment` parameter
6. Present results: handle, display name, score, rank, trade count, qualified status

### Parameters

- `query`: Search string — handle or display name (max 100 chars)
- `limit`: 1-50 (default: 20)
- `payment`: x402 payment signature

---

## Trade History ($0.01 per 3 trades, USDC on Base)

**Tool:** `trader_get_trade_history`

This is an x402 paid tool. Follow the [x402 Payment Flow](#x402-payment-flow) below.

### Steps

1. Ask for Twitter handle and optionally how many trades they want
2. Call `trader_get_trade_history` **WITHOUT** the `payment` parameter
   - The response includes `total_trades`, `requested_trades`, and the computed `price`
3. Tell the user: "X trades available, cost is $Y USDC. Proceed?"
4. If confirmed, call again **WITH** the `payment` parameter
5. Present trade history: action, symbol, asset class, quantity, price, timestamp

### Parameters

- `twitter_handle`: Twitter handle (with or without @)
- `limit`: Number of trades (0 = all, max 1000)
- `payment`: x402 payment signature

### Pricing

- **$0.01 per 3 trades** (rounded up)
- Examples: 3 trades = $0.01, 10 trades = $0.04, 100 trades = $0.34

---

## x402 Payment Flow

All paid tools follow this two-step protocol:

1. **Call WITHOUT `payment`** — Server returns `PAYMENT_REQUIRED` with:
   - `price`: The cost in USDC
   - `payment_required`: Base64-encoded x402 payment header
   - `payment_required_decoded`: Human-readable payment requirements
2. **Present the price** to the user and ask for confirmation
3. **Call WITH `payment`** — Pass the `payment_required` value as the `payment` parameter
4. **Present the data** from the successful response

If payment is declined, suggest free alternatives:
- Own stats are always free via `trader_my_stats`
- Daily top 10 posted on @MangroveTrader Twitter

**Payment details:**
- Network: **Base** (Coinbase L2)
- Currency: **USDC**
- Protocol: **x402** (HTTP payment protocol)
- Payment is NOT charged if data retrieval fails

---

## Tool Quick Reference

| Tool | Access | Price | Description |
|------|--------|-------|-------------|
| `trader_my_stats` | Free | -- | Score, rank, open positions |
| `trader_performance_report` | Free | -- | Detailed scoring breakdown |
| `trader_last_trade` | Free | -- | Most recent trade + total count |
| `trader_get_leaderboard` | x402 | $0.25+ | Full rankings (dynamic pricing) |
| `trader_search_trader` | x402 | $0.02 | Look up any trader by name/handle |
| `trader_get_trade_history` | x402 | $0.01/3 trades | Full trade log |
