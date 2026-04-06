# Fly.io Deployment Guide

## Deploy to Fly.io

1. **Install Fly CLI:**
   ```bash
   # macOS
   brew install flyctl

   # Or download from: https://fly.io/docs/getting-started/installing-flyctl/
   ```

2. **Login to Fly:**
   ```bash
   fly auth login
   ```

3. **Initialize App:**
   ```bash
   cd /path/to/your/project
   fly launch
   # Follow prompts, use existing fly.toml when asked
   ```

4. **Set Environment Variables:**
   ```bash
   fly secrets set TELEGRAM_BOT_TOKEN=your_bot_token_here
   fly secrets set OPENWEATHER_API_KEY=your_api_key_here  # optional
   ```

5. **Deploy:**
   ```bash
   fly deploy
   ```

## Configuration

The `fly.toml` file is already configured with:
- **Region:** Singapore (closest to India)
- **Python Version:** 3.10
- **Port:** 8080
- **Process:** Telegram bot

## Monitoring

```bash
# Check app status
fly status

# View logs
fly logs

# SSH into app
fly ssh console
```

## Notes
- Fly.io has a generous free tier
- Apps can run 24/7
- Easy scaling and monitoring
- Global CDN for fast access
