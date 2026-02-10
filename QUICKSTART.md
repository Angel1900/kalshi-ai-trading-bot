# Quick Start Guide

Get the Kalshi AI Trading Bot up and running in 15 minutes.

## Prerequisites

- Docker and Docker Compose installed
- Kalshi API credentials (sign up at kalshi.com)
- OpenAI API key (https://platform.openai.com)
- Anthropic API key (https://console.anthropic.com)
- Discord webhook URL (optional, for alerts)

## Step 1: Clone Repository

```bash
git clone https://github.com/Angel1900/kalshi-ai-trading-bot.git
cd kalshi-ai-trading-bot
```

## Step 2: Configure Environment

```bash
cp .env.example .env
nano .env  # Edit with your API keys
```

**Critical settings:**
- Set `LIVE_TRADING=false` for paper trading mode
- Add your API keys for Kalshi, OpenAI, Anthropic
- Configure Discord webhook (optional)

## Step 3: Start Services

```bash
# Build and start all services
docker-compose up -d --build

# Verify services are running
docker-compose ps

# View bot logs
docker-compose logs -f bot
```

## Step 4: Access Dashboards

**Grafana Dashboard** (Real-time trading metrics):
- URL: http://localhost:3000
- Username: admin
- Password: admin (change in .env)

**Prometheus Metrics** (Raw metrics):
- URL: http://localhost:9090

## Step 5: Paper Trading

Test the bot with simulated trades:

```bash
# Keep LIVE_TRADING=false in .env
# Run for 2-4 weeks to validate strategy
# Monitor Grafana dashboard for performance
```

## Step 6: Enable Live Trading

Once confident:

```bash
# Edit .env
echo "LIVE_TRADING=true" >> .env

# Deposit $50 minimum to Kalshi
# Restart bot
docker-compose restart bot
```

## Common Commands

```bash
# View logs
docker-compose logs -f bot

# Stop bot
docker-compose down

# Restart bot
docker-compose restart bot

# View database
docker-compose exec postgres psql -U kalshi_user -d kalshi_db

# View Redis
docker-compose exec redis redis-cli
```

## Troubleshooting

### Bot not trading?
1. Check logs: `docker-compose logs bot | tail -50`
2. Verify API keys are set correctly
3. Check Kalshi API is accessible: `curl https://api.kalshi.com/`
4. Ensure market discovery is working (check database)

### High memory usage?
1. Reduce concurrent positions: `MAX_POSITIONS=5`
2. Increase scan interval: `SCAN_INTERVAL=600`

### Can't access Grafana?
1. Check port 3000 is not in use: `lsof -i :3000`
2. Verify container is running: `docker-compose ps grafana`
3. Check Prometheus is connected to bot

## Next Steps

1. **Backtest Strategy**: Test on historical data before deploying
2. **Monitor Performance**: Review Grafana dashboard daily
3. **Adjust Parameters**: Tune risk limits and edge threshold
4. **Scale Up**: Once profitable, increase bankroll and positions

## Support

- GitHub Issues: Report bugs and request features
- Discord: Join the community (add link)
- Documentation: Read the full architecture guide (README.md)

## ⚠️ Risk Warning

Prediction market trading carries significant risk. This bot does not guarantee profits. 

- Start with paper trading (no real money)
- Use only capital you can afford to lose
- Monitor the bot regularly
- Scale slowly as you validate profitability
