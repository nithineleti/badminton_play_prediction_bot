# Railway Deployment Guide

## Deploy to Railway

Railway is the easiest way to deploy your bot with zero configuration.

1. **Connect Repository:**
   - Go to [Railway Dashboard](https://railway.app)
   - Click "New Project" → "Deploy from GitHub repo"
   - Connect your repository

2. **Automatic Deployment:**
   - Railway will automatically detect Python
   - It will use `requirements.txt` for dependencies
   - It will use `start.sh` as the start command

3. **Set Environment Variables:**
   In Railway dashboard → Variables:
   ```
   TELEGRAM_BOT_TOKEN=your_bot_token_here
   OPENWEATHER_API_KEY=your_api_key_here  # optional
   ```

4. **Deploy:**
   - Click "Deploy"
   - Railway will build and start your bot automatically

## Configuration Files

Railway uses these existing files:
- `requirements.txt` - Python dependencies
- `start.sh` - Startup script
- `runtime.txt` - Python version
- `Procfile` - Process definition (optional)

## Monitoring

- **Logs:** View in Railway dashboard
- **Metrics:** CPU, memory, and request stats
- **Environment:** Full control over env vars

## Notes
- Railway has a generous free tier ($5/month credit)
- Perfect for 24/7 bot hosting
- Automatic HTTPS certificates
- Global CDN included
