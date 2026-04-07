# 🚀 Deployment Guide

This guide covers multiple ways to deploy your Badminton Wind Predictor Bot to production.

## Quick Comparison

| Platform | Difficulty | Free Tier | 24/7 Uptime | Setup Time | Best For |
|----------|------------|-----------|-------------|------------|----------|
| **Railway** | ⭐⭐⭐ | $5 credit | ✅ | 5 minutes | Long-running bots |
| **AWS** | ⭐⭐⭐⭐⭐ | 750 hours EC2 | ✅ | 15 minutes | Enterprise & scaling |
| **Render** | ⭐⭐⭐⭐ | 750 hours | ✅ | 10 minutes | Web apps & APIs |
| **Fly.io** | ⭐⭐⭐⭐⭐ | Generous | ✅ | 15 minutes | Advanced scaling |
| **Hugging Face** | ⭐⭐⭐ | Unlimited | ❌ | 10 minutes | Web demos |

## 🎯 Recommended Options

### 🏆 Railway (Easiest for Bots)
Railway offers the best balance of ease and reliability for long-running bots.

### 🌐 Hugging Face (Best for Web UI)
Hugging Face Spaces is ideal for web-based demos and interfaces.

### Deploy Steps:
1. Go to [Railway.app](https://railway.app)
2. Connect your GitHub repo
3. Set `TELEGRAM_BOT_TOKEN` environment variable
4. Deploy automatically

See `deployment/railway/README.md` for detailed instructions.

## 🌐 Alternative Platforms

### Render
- Free tier: 750 hours/month
- Good for web apps
- See `deployment/render/README.md`

### AWS Elastic Beanstalk
- Enterprise-grade infrastructure
- 750 hours EC2 free tier
- See `deployment/aws/README.md`

### Fly.io
- Most powerful free tier
- Global deployment
- See `deployment/fly/README.md`

### Hugging Face Spaces
- Best for web interface
- Free unlimited hosting
- See `deployment/hf_space/`

## 🔧 Environment Variables

All platforms need these environment variables:

```bash
TELEGRAM_BOT_TOKEN=your_bot_token_here          # Required
OPENWEATHER_API_KEY=your_api_key_here           # Optional
PYTHON_VERSION=3.10.0                           # Recommended
```

## 📊 Monitoring & Logs

- **Railway:** Dashboard → Logs tab
- **Render:** Dashboard → Logs section
- **Fly.io:** `fly logs` command
- **Hugging Face:** Spaces → Logs

## 🆘 Troubleshooting

### Bot Not Starting
1. Check environment variables are set
2. Verify bot token is valid
3. Check logs for error messages

### High Resource Usage
- Railway/Render: Upgrade plan if needed
- Fly.io: Scale horizontally with `fly scale`

### Token Issues
- Regenerate token from @BotFather
- Update environment variable
- Redeploy

## 💡 Pro Tips

- **Railway** is perfect for beginners
- **Fly.io** offers the most control
- **Hugging Face** is great for web demos
- All platforms support automatic HTTPS

Choose based on your needs and experience level!
