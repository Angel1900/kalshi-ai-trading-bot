# Kalshi AI Trading Bot 🤖📈

An autonomous prediction market trading system that combines **LLM-based probability modeling**, **real-time market monitoring**, **fractional Kelly position sizing**, and **multi-layer risk management** to systematically extract edge from Kalshi markets with $50 starting capital.

## 🎯 Overview

This system operates 24/7 on a minimal $12/month server, automatically:
- Monitors 200+ Kalshi prediction markets in real-time
- Estimates fair probabilities using GPT-4o + Claude 3.7 ensemble
- Detects profitable edges (5%+ mispricing)
- Places limit orders with fractional Kelly sizing
- Manages positions with multi-layer risk controls
- Generates daily performance reports via Discord

## 📊 Projected Returns

| Scenario | Win Rate | Daily P&L | Annual ROI |
|----------|----------|-----------|------------|
| Conservative | 60% | $0.50 | 360% |
| Realistic | 65% | $1.80 | 1,296% |
| Optimistic | 70% | $4.50 | 3,240% |

## 🏗️ Architecture

```
DATA ENGINE ──▶ AI BRAIN ──▶ EXECUTION ENGINE
    ↓               ↓              ↓
  • Real-time   • Probability   • Order Management
    WebSocket     Modeling      • Risk Management
  • Market      • Edge Calc     • Position Tracking
    Scanner     • Correlation
  • News/Event    Detection
    Data
        ↓               ↓              ↓
    PostgreSQL + TimescaleDB + Redis (Persistence)
        ↓               ↓              ↓
  Prometheus + Grafana + Discord (Monitoring)
```

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Kalshi API credentials
- OpenAI API key (GPT-4o)
- Anthropic API key (Claude 3.7)
- Discord webhook URL (optional, for alerts)

### Installation

```bash
# Clone repository
git clone https://github.com/Angel1900/kalshi-ai-trading-bot.git
cd kalshi-ai-trading-bot

# Configure environment
cp .env.example .env
nano .env  # Add your API keys

# Start system
docker-compose up -d --build

# Verify services
docker-compose ps
docker-compose logs -f bot

# Access dashboards
# Grafana: http://localhost:3000 (admin/admin)
# Prometheus: http://localhost:9090
```

### Paper Trading (Recommended First)

```bash
# Test strategy for 2 weeks without real capital
echo "LIVE_TRADING=false" >> .env
docker-compose restart bot

# Monitor in Grafana → Dashboard → Kalshi Bot
# Once confident, enable live trading
echo "LIVE_TRADING=true" >> .env
docker-compose restart bot
```

## 📁 Project Structure

```
kalshi-ai-trading-bot/
├── src/
│   ├── main.py                 # Main bot orchestrator
│   ├── config.py               # Configuration & env vars
│   ├── data_engine/
│   │   ├── websocket_client.py # Real-time orderbook
│   │   ├── market_scanner.py   # Market discovery
│   │   └── data_aggregator.py  # News/event data
│   ├── ai_brain/
│   │   ├── probability_oracle.py    # GPT-4o + Claude ensemble
│   │   ├── edge_calculator.py       # EV & Kelly sizing
│   │   └── correlation_manager.py   # Portfolio correlation check
│   ├── execution_engine/
│   │   ├── order_executor.py   # Order placement & lifecycle
│   │   ├── position_manager.py # Position tracking & exits
│   │   └── risk_manager.py     # Multi-layer risk controls
│   └── monitoring/
│       ├── prometheus_metrics.py    # Metrics export
│       └── discord_alerts.py        # Real-time notifications
├── database/
│   ├── schema.sql              # PostgreSQL + TimescaleDB schema
│   └── migrations/
├── docker-compose.yml          # Container orchestration
├── Dockerfile                  # Bot container image
├── requirements.txt            # Python dependencies
├── prometheus.yml              # Prometheus config
├── grafana/
│   └── dashboards/             # Pre-built Grafana dashboards
├── .env.example                # Environment template
└── README.md                   # This file
```

## 🔧 Configuration

### Environment Variables (.env)

```bash
# Kalshi API
KALSHI_API_KEY=your_api_key
KALSHI_API_SECRET=your_api_secret
KALSHI_SANDBOX=false  # Set to true for testing

# AI Models
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...

# Database
DATABASE_URL=postgresql://user:pass@postgres:5432/kalshi
REDIS_URL=redis://redis:6379

# Monitoring
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/...

# Trading Parameters
INITIAL_BANKROLL=50.0           # Starting capital in $
MAX_RISK_PER_TRADE=1.0          # Max risk per position (2% of bankroll)
MAX_TOTAL_RISK=10.0             # Max simultaneous risk (20%)
FRACTIONAL_KELLY=0.25           # Kelly fraction (0.25 = 1/4 Kelly)
MIN_EDGE=0.05                   # Minimum edge required (5%)

# Features
LIVE_TRADING=false              # Start with paper trading
AUTO_DEPOSIT_PROFITS=true       # Auto-reinvest profits
```

## 📊 Key Features

### 1. Real-Time Market Monitoring
- WebSocket connection to Kalshi orderbooks
- 200+ market scanning every 5 minutes
- Automatic discovery of new trading opportunities

### 2. LLM-Based Probability Modeling
- GPT-4o + Claude 3.7 Sonnet ensemble
- Structured prompt engineering for calibrated estimates
- Uncertainty quantification with confidence intervals
- Context aggregation from news, economic data, and events

### 3. Intelligent Position Sizing
- Fractional Kelly Criterion for optimal sizing
- Confidence-adjusted position scaling
- Correlation detection to prevent portfolio clumping
- Category exposure limits (sports, politics, economics, etc.)

### 4. Multi-Layer Risk Management
- **Per-trade limit**: $1 max risk per position
- **Portfolio limit**: $10 max simultaneous risk
- **Category limit**: $6 max per market category
- **Daily limit**: $5 max daily loss (trading halts)
- **Drawdown breaker**: 20% max drawdown triggers circuit breaker

### 5. Automated Exit Logic
- **Take profit**: Close at 90¢ (very confident outcomes)
- **Edge evaporated**: Close when fair value ±2% of market
- **Stop loss**: Close when fair value drops 10% below entry
- **Time decay**: Close within 24hrs if edge < 5%

### 6. Real-Time Monitoring
- Grafana dashboard with equity curve, positions, trades
- Prometheus metrics: P&L, bankroll, win rate, API latency
- Discord alerts: new trades, risk breaches, daily summaries

## 💰 Cost Analysis

| Component | Monthly Cost | Notes |
|-----------|--------------|-------|
| Server (DigitalOcean 2GB) | $12 | Scalable to $24/48GB |
| OpenAI API (GPT-4o) | ~$30 | 1,000 estimates/mo |
| Anthropic API (Claude) | ~$25 | Backup model |
| News APIs | $15 | NewsAPI, MarketAux, etc. |
| Domain/SSL | $2 | Optional |
| **Total** | **~$84/mo** | Break-even at +168% ROI |

## 🔍 How It Works

### Trading Flow

1. **Market Discovery** (5-min cycle)
   - Scan all Kalshi markets for liquidity and volume
   - Filter for markets closing 1-30 days out
   - Add qualifying markets to watchlist

2. **Context Aggregation** (per market)
   - Fetch recent news, economic data, event info
   - Compile historical base rates for category
   - Gather real-time social sentiment (if available)

3. **Probability Estimation**
   - Feed context to GPT-4o + Claude ensemble
   - Each model independently estimates YES probability
   - Weighted ensemble (55% GPT, 45% Claude)
   - Calculate confidence intervals

4. **Edge Detection**
   - Compare fair value to current market prices
   - Calculate expected value after fees
   - Apply confidence adjustment
   - Filter for minimum 5% edge

5. **Correlation Check**
   - Semantic similarity of market titles
   - Category-based exposure analysis
   - Block entry if too correlated

6. **Position Sizing**
   - Calculate Kelly Criterion for position size
   - Apply 1/4 Kelly safety factor
   - Respect all multi-layer risk limits

7. **Order Placement**
   - Place limit orders on maker side (lower fees)
   - 10-minute timeout for unfilled orders
   - Cancel stale orders before re-evaluation

8. **Position Management** (1-min cycle)
   - Evaluate exit conditions every minute
   - Close if take profit, edge evaporated, or stop loss
   - Log all trades for analysis and backtesting

9. **Monitoring & Alerts**
   - Prometheus exports all metrics
   - Grafana displays live dashboard
   - Discord sends real-time notifications

## 📈 Backtesting

The system includes a backtesting framework to validate strategy changes:

```bash
# Backtest on historical data
python -m src.backtest \
  --start-date 2024-01-01 \
  --end-date 2024-12-31 \
  --initial-bankroll 50 \
  --output results.json

# Results include:
# - Total return and Sharpe ratio
# - Win rate and average trade duration
# - Max drawdown and recovery time
# - Probability calibration curve
```

## 🛠️ Development

### Local Development Setup

```bash
# Install dependencies
pip install -r requirements.txt

# Run tests
pytest tests/

# Lint code
flake8 src/
black src/

# Type checking
mypy src/
```

### Adding New Features

1. Create feature branch: `git checkout -b feature/your-feature`
2. Make changes and test locally
3. Push and create pull request
4. Merge to `dev` after review
5. Deploy to production from `main`

## 🔐 Security

- API keys stored in environment variables (never in code)
- Docker network isolates services internally
- PostgreSQL behind internal network (no external access)
- Webhook URLs encrypted in Redis
- All trades logged for audit trail

## 📝 Logging & Debugging

```bash
# View bot logs
docker-compose logs -f bot

# View database logs
docker-compose logs postgres

# Connect to PostgreSQL
docker-compose exec postgres psql -U user -d kalshi

# Connect to Redis
docker-compose exec redis redis-cli
```

## 🚀 Deployment

### Production Deployment (DigitalOcean)

```bash
# SSH into server
ssh root@your.server.ip

# Clone repo
git clone https://github.com/Angel1900/kalshi-ai-trading-bot.git
cd kalshi-ai-trading-bot

# Configure environment
cp .env.example .env
vim .env  # Add production API keys

# Start system
docker-compose up -d --build

# Enable auto-restart on reboot
docker update --restart unless-stopped $(docker ps -q)

# Access Grafana
# Open browser: http://your.server.ip:3000
```

### AWS EC2 Deployment

```bash
# Similar process on t3.small instance
# See AWS_DEPLOYMENT.md for detailed guide
```

## 🐛 Troubleshooting

### Bot not trading?
- Check logs: `docker-compose logs bot | tail -50`
- Verify API keys in `.env`
- Ensure Kalshi API is accessible: `curl https://api.kalshi.com/`
- Check market discovery: look for entries in `market_snapshots` table

### High API costs?
- Increase `scan_interval` in market_scanner.py (trade discovery speed)
- Reduce news API calls (cache longer)
- Use cheaper Claude for secondary probabilities

### Discord alerts not working?
- Verify webhook URL in `.env`
- Check webhook still valid in Discord settings
- Review Discord server permissions

## 📚 Resources

- [Kalshi API Documentation](https://docs.kalshi.com/)
- [OpenAI GPT-4 Guide](https://platform.openai.com/docs/guides/gpt-4)
- [Anthropic Claude API](https://console.anthropic.com/)
- [Kelly Criterion Explained](https://en.wikipedia.org/wiki/Kelly_criterion)
- [Prediction Markets Guide](https://www.lesswrong.com/posts/QsLXQhMXQm4dBfU9P)

## 📄 License

MIT License - See LICENSE file

## 💬 Support

For issues, questions, or feature requests:
- Open an issue on GitHub
- Start a discussion in the community
- Check existing issues for solutions

## 🎯 Roadmap

- [ ] **Phase 1**: MVP with $50 bankroll, basic risk management
- [ ] **Phase 2**: Model fine-tuning on historical Kalshi data
- [ ] **Phase 3**: Multi-account orchestration
- [ ] **Phase 4**: Cross-platform arbitrage (Polymarket, PredictIt)
- [ ] **Phase 5**: Hedge fund LP structure

## 👤 Author

Built by an active-duty Marine Corps member for autonomous wealth generation alongside military service.

---

**⚠️ Risk Disclaimer**: Prediction market trading carries risk of loss. This system does not guarantee profits. Start with paper trading and small capital. Only risk what you can afford to lose.
