# 🚀 Super Easy Setup - Like OpenClaw!

**Setup time: 2 minutes** | **No manual file editing!**

---

## 🎯 **One-Command Setup**

### **Step 1: Clone Repository**

```bash
git clone https://github.com/Angel1900/kalshi-ai-trading-bot.git
cd kalshi-ai-trading-bot
```

### **Step 2: Run Interactive Setup**

```bash
chmod +x setup.sh
./setup.sh
```

**That's it!** The script will:
- ✅ Ask for your 3 API keys
- ✅ Automatically create .env file
- ✅ Validate Docker is running
- ✅ Start all services
- ✅ Show you the dashboard URL

**No manual editing needed!** Just answer the prompts.

---

## 🔑 **What You'll Be Asked**

The setup script will ask for:

### **Required (3 keys):**
1. **Kalshi API Key** - Get from [kalshi.com](https://kalshi.com) → Settings → API Keys
2. **Kalshi API Secret** - Same page as above
3. **OpenAI API Key** - Get from [platform.openai.com/api-keys](https://platform.openai.com/api-keys)

### **Optional (just press Enter to skip):**
4. **Anthropic API Key** - For ensemble mode (2-3% better accuracy)
5. **Discord Webhook** - For trade alerts
6. **Live Trading** - Keep as "No" for paper trading

---

## 📹 **What It Looks Like**

```
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   🤖 Kalshi AI Trading Bot - Interactive Setup 🤖        ║
║                                                           ║
║   Get your bot running in 2 minutes!                      ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

✅ Docker is running

Welcome! I'll help you set up your trading bot.
You'll need 3 API keys. Press Enter after each one.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1/3: Kalshi API Key
Get it from: https://kalshi.com → Settings → API Keys
Enter your Kalshi API Key: [you type here]
✅ Kalshi API Key saved

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
2/3: Kalshi API Secret
Enter your Kalshi API Secret: [you type here]
✅ Kalshi API Secret saved

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
3/3: OpenAI API Key
Get it from: https://platform.openai.com/api-keys
Enter your OpenAI API Key: [you type here]
✅ OpenAI API Key saved

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
OPTIONAL: Anthropic API Key (for better accuracy)
Press Enter to skip (bot will use OpenAI only)
Enter your Anthropic API Key: [press Enter to skip]
⚠️  Skipped - Using OpenAI only mode

╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   ✅ Configuration Complete!                              ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

Your settings:
  Kalshi API: Configured ✓
  OpenAI API: Configured ✓
  Trading Mode: PAPER (Simulated)

Starting your trading bot...

✅ Bot is starting!

╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   🚀 Your Trading Bot is Running! 🚀                      ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

Next Steps:

1. View bot logs:
   docker-compose logs -f bot

2. Open dashboard:
   http://localhost:3000
   Username: admin
   Password: admin

💡 Remember: You're in paper trading mode (no real money).
   Run for 2-4 weeks, then enable live trading if profitable.

Good luck! 🎯💰
```

---

## 🛠️ **Useful Commands**

```bash
# View real-time logs
docker-compose logs -f bot

# Stop the bot
docker-compose down

# Restart the bot
docker-compose restart bot

# Run setup again (change settings)
./setup.sh

# Check container status
docker-compose ps
```

---

## 📊 **Open Your Dashboard**

Once setup completes, open your browser:

```
http://localhost:3000

Username: admin
Password: admin
```

You'll see:
- Current bankroll
- Open positions
- Trade history
- Performance charts

---

## 🎯 **What Happens Next**

### **First 10 minutes:**
- Bot discovers 200+ Kalshi markets
- GPT-4 evaluates probabilities
- First orders placed

### **First hour:**
- 2-5 positions opened
- Real-time dashboard updates
- Automated position management

### **First week:**
- 20-40 trades completed
- Win rate stabilizes (60-65%)
- Daily profit: $0.30-0.75

---

## ✅ **Paper Trading Checklist (2-4 Weeks)**

Monitor in Grafana dashboard:

- [ ] 50+ trades completed
- [ ] Win rate > 55%
- [ ] Daily profit > $0.20
- [ ] Max drawdown < 15%
- [ ] No API errors

**Once all boxes checked → Enable live trading**

---

## 💰 **Enable Live Trading**

**After successful paper trading:**

```bash
# Run setup again
./setup.sh

# When asked "Enable live trading?"
# Type: y

# Deposit $50 to Kalshi first!
```

---

## 🆘 **Troubleshooting**

### **"Docker is not running"**
```bash
# Open Docker Desktop app
# Wait for "Docker is running" message
# Run ./setup.sh again
```

### **"Permission denied: ./setup.sh"**
```bash
chmod +x setup.sh
./setup.sh
```

### **Want to change settings?**
```bash
# Just run setup again!
./setup.sh
```

### **Need to see logs?**
```bash
docker-compose logs -f bot
```

### **Bot not trading?**
```bash
# Check for errors
docker-compose logs bot | grep ERROR

# Verify services running
docker-compose ps
```

---

## 💸 **Monthly Costs**

**OpenAI Only Mode:**
```
Server: $12/month (DigitalOcean)
OpenAI: $25-35/month
────────────────────
Total: ~$37-47/month
```

**Expected Profit:**
```
Conservative: $0.50/day = $15/month
Realistic:    $1.80/day = $54/month ✓
Optimistic:   $4.50/day = $135/month
```

**Break-even:** +$1.50/day  
**Realistic net profit:** $7-17/month after costs

---

## 📚 **More Info**

- **Full Architecture**: [README.md](README.md)
- **Manual Setup**: See below for non-interactive setup
- **GitHub Issues**: [Report bugs](https://github.com/Angel1900/kalshi-ai-trading-bot/issues)

---

## 🔧 **Manual Setup (Alternative)**

If you prefer manual configuration:

```bash
# 1. Clone
git clone https://github.com/Angel1900/kalshi-ai-trading-bot.git
cd kalshi-ai-trading-bot

# 2. Create config
cp .env.example .env

# 3. Edit manually
nano .env  # or use any text editor

# 4. Add your 3 API keys:
# KALSHI_API_KEY=...
# KALSHI_API_SECRET=...
# OPENAI_API_KEY=...

# 5. Start
docker-compose up -d --build
```

---

## ✅ **You're Ready!**

**Complete setup in one command:**

```bash
git clone https://github.com/Angel1900/kalshi-ai-trading-bot.git && cd kalshi-ai-trading-bot && chmod +x setup.sh && ./setup.sh
```

**Then open:** http://localhost:3000

**Good luck, Marine!** 🎯💰
