# Render Deployment Guide

## Deploy to Render

1. **Connect Repository:**
   - Go to [Render Dashboard](https://dashboard.render.com)
   - Click "New" → "Web Service"
   - Connect your GitHub repository

2. **Configure Service:**
   - **Name:** badminton-bot
   - **Environment:** Python
   - **Build Command:** `pip install -r requirements.txt && python scripts/make_sample_data.py`
   - **Start Command:** `python -m src.integrations.telegram_bot`

3. **Environment Variables:**
   Add these in Render dashboard:
   ```
   TELEGRAM_BOT_TOKEN=your_bot_token_here
   PYTHON_VERSION=3.10.0
   ```

4. **Deploy:**
   - Click "Create Web Service"
   - Render will build and deploy automatically

## Notes
- Render has a free tier with 750 hours/month
- The bot will run 24/7 on Render's servers
- Monitor logs in Render dashboard for any issues
