#!/bin/bash

# Kalshi AI Trading Bot - Interactive Setup Script
# Makes setup as easy as OpenClaw!

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   🤖 Kalshi AI Trading Bot - Interactive Setup 🤖        ║
║                                                           ║
║   Get your bot running in 2 minutes!                      ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Check if Docker is running
echo -e "${YELLOW}Checking Docker...${NC}"
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running!${NC}"
    echo -e "${YELLOW}Please start Docker Desktop and run this script again.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Docker is running${NC}"
echo ""

# Welcome message
echo -e "${GREEN}Welcome! I'll help you set up your trading bot.${NC}"
echo -e "${YELLOW}You'll need 3 API keys. Press Enter after each one.${NC}"
echo ""
sleep 1

# Create .env file from example if it doesn't exist
if [ ! -f .env ]; then
    cp .env.example .env
    echo -e "${GREEN}✅ Created .env configuration file${NC}"
else
    echo -e "${YELLOW}⚠️  .env file already exists. I'll update it.${NC}"
fi
echo ""

# Function to update .env file
update_env() {
    local key=$1
    local value=$2
    # Escape special characters in value
    value=$(echo "$value" | sed 's/[&/\\]/\\&/g')
    
    if grep -q "^${key}=" .env; then
        # Key exists, replace it
        sed -i.bak "s|^${key}=.*|${key}=${value}|" .env
    else
        # Key doesn't exist, add it
        echo "${key}=${value}" >> .env
    fi
}

# Kalshi API Key
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}1/3: Kalshi API Key${NC}"
echo -e "${YELLOW}Get it from: https://kalshi.com → Settings → API Keys${NC}"
echo -e "${YELLOW}(Should start with 'kal_')${NC}"
echo -n "Enter your Kalshi API Key: "
read -r KALSHI_KEY

while [ -z "$KALSHI_KEY" ]; do
    echo -e "${RED}❌ API key cannot be empty!${NC}"
    echo -n "Enter your Kalshi API Key: "
    read -r KALSHI_KEY
done

update_env "KALSHI_API_KEY" "$KALSHI_KEY"
echo -e "${GREEN}✅ Kalshi API Key saved${NC}"
echo ""

# Kalshi API Secret
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}2/3: Kalshi API Secret${NC}"
echo -e "${YELLOW}From the same page as your API key${NC}"
echo -n "Enter your Kalshi API Secret: "
read -r KALSHI_SECRET

while [ -z "$KALSHI_SECRET" ]; do
    echo -e "${RED}❌ API secret cannot be empty!${NC}"
    echo -n "Enter your Kalshi API Secret: "
    read -r KALSHI_SECRET
done

update_env "KALSHI_API_SECRET" "$KALSHI_SECRET"
echo -e "${GREEN}✅ Kalshi API Secret saved${NC}"
echo ""

# OpenAI API Key
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}3/3: OpenAI API Key${NC}"
echo -e "${YELLOW}Get it from: https://platform.openai.com/api-keys${NC}"
echo -e "${YELLOW}(Should start with 'sk-')${NC}"
echo -n "Enter your OpenAI API Key: "
read -r OPENAI_KEY

while [ -z "$OPENAI_KEY" ]; do
    echo -e "${RED}❌ API key cannot be empty!${NC}"
    echo -n "Enter your OpenAI API Key: "
    read -r OPENAI_KEY
done

update_env "OPENAI_API_KEY" "$OPENAI_KEY"
echo -e "${GREEN}✅ OpenAI API Key saved${NC}"
echo ""

# Optional: Anthropic API Key
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}OPTIONAL: Anthropic API Key (for better accuracy)${NC}"
echo -e "${YELLOW}Get it from: https://console.anthropic.com${NC}"
echo -e "${YELLOW}Press Enter to skip (bot will use OpenAI only)${NC}"
echo -n "Enter your Anthropic API Key (or press Enter to skip): "
read -r ANTHROPIC_KEY

if [ -n "$ANTHROPIC_KEY" ]; then
    update_env "ANTHROPIC_API_KEY" "$ANTHROPIC_KEY"
    echo -e "${GREEN}✅ Anthropic API Key saved (Ensemble mode enabled)${NC}"
else
    echo -e "${YELLOW}⚠️  Skipped - Using OpenAI only mode${NC}"
fi
echo ""

# Optional: Discord Webhook
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}OPTIONAL: Discord Webhook URL (for trade alerts)${NC}"
echo -e "${YELLOW}Press Enter to skip${NC}"
echo -n "Enter your Discord Webhook URL (or press Enter to skip): "
read -r DISCORD_WEBHOOK

if [ -n "$DISCORD_WEBHOOK" ]; then
    update_env "DISCORD_WEBHOOK_URL" "$DISCORD_WEBHOOK"
    echo -e "${GREEN}✅ Discord webhook saved${NC}"
else
    echo -e "${YELLOW}⚠️  Skipped - No Discord alerts${NC}"
fi
echo ""

# Live Trading Mode
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}⚠️  IMPORTANT: Trading Mode${NC}"
echo -e "${YELLOW}Start with PAPER TRADING (no real money) to test the bot.${NC}"
echo -e "${YELLOW}Enable live trading only after 2-4 weeks of successful paper trading.${NC}"
echo ""
echo -e "${YELLOW}Enable live trading now? (y/N):${NC} "
read -r LIVE_TRADING_INPUT

if [[ "$LIVE_TRADING_INPUT" =~ ^[Yy]$ ]]; then
    update_env "LIVE_TRADING" "true"
    echo -e "${RED}⚠️  LIVE TRADING ENABLED - Real money will be used!${NC}"
else
    update_env "LIVE_TRADING" "false"
    echo -e "${GREEN}✅ Paper trading mode (no real money)${NC}"
fi
echo ""

# Clean up backup file
rm -f .env.bak

# Summary
echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   ✅ Configuration Complete!                              ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${GREEN}Your settings:${NC}"
echo -e "  Kalshi API: ${GREEN}Configured ✓${NC}"
echo -e "  OpenAI API: ${GREEN}Configured ✓${NC}"

if [ -n "$ANTHROPIC_KEY" ]; then
    echo -e "  Anthropic API: ${GREEN}Configured ✓${NC} (Ensemble mode)"
else
    echo -e "  Anthropic API: ${YELLOW}Not configured${NC} (OpenAI only mode)"
fi

if [ -n "$DISCORD_WEBHOOK" ]; then
    echo -e "  Discord Alerts: ${GREEN}Configured ✓${NC}"
else
    echo -e "  Discord Alerts: ${YELLOW}Not configured${NC}"
fi

if [[ "$LIVE_TRADING_INPUT" =~ ^[Yy]$ ]]; then
    echo -e "  Trading Mode: ${RED}LIVE (Real Money)${NC}"
else
    echo -e "  Trading Mode: ${GREEN}PAPER (Simulated)${NC}"
fi

echo ""
echo -e "${YELLOW}Starting your trading bot...${NC}"
echo ""

# Start Docker Compose
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Building and starting containers...${NC}"
echo -e "${YELLOW}(This takes 2-3 minutes the first time)${NC}"
echo ""

# Use --no-cache to ensure fresh package installation
docker-compose build --no-cache bot
docker-compose up -d

echo ""
echo -e "${GREEN}✅ Bot is starting!${NC}"
echo ""

# Wait for services to start
echo -e "${YELLOW}Waiting for services to start...${NC}"
sleep 5

# Check status
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Service Status:${NC}"
docker-compose ps
echo ""

# Final instructions
echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   🚀 Your Trading Bot is Running! 🚀                      ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${GREEN}Next Steps:${NC}"
echo ""
echo -e "${YELLOW}1. View bot logs:${NC}"
echo -e "   ${BLUE}docker-compose logs -f bot${NC}"
echo ""
echo -e "${YELLOW}2. Open dashboard:${NC}"
echo -e "   ${BLUE}http://localhost:3000${NC}"
echo -e "   Username: ${GREEN}admin${NC}"
echo -e "   Password: ${GREEN}admin${NC}"
echo ""
echo -e "${YELLOW}3. Useful commands:${NC}"
echo -e "   View logs:     ${BLUE}docker-compose logs -f bot${NC}"
echo -e "   Stop bot:      ${BLUE}docker-compose down${NC}"
echo -e "   Restart bot:   ${BLUE}docker-compose restart bot${NC}"
echo -e "   Update config: ${BLUE}./setup.sh${NC} (run this script again)"
echo ""

if [[ ! "$LIVE_TRADING_INPUT" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}💡 Remember:${NC} You're in paper trading mode (no real money)."
    echo -e "   Run for 2-4 weeks, then enable live trading if profitable."
    echo -e "   To enable live trading: ${BLUE}./setup.sh${NC}"
else
    echo -e "${RED}⚠️  LIVE TRADING ACTIVE${NC}"
    echo -e "   Real money is being used! Monitor closely."
fi

echo ""
echo -e "${GREEN}Good luck! 🎯💰${NC}"
echo ""
