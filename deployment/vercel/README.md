# Vercel Deployment Guide

## Deploy to Vercel

Vercel supports serverless functions, perfect for handling Telegram webhooks.

### 🚀 Quick Deploy

1. **Install Vercel CLI:**
   ```bash
   npm install -g vercel
   # or
   yarn global add vercel
   ```

2. **Login to Vercel:**
   ```bash
   vercel login
   ```

3. **Deploy:**
   ```bash
   vercel --prod
   ```

4. **Set Environment Variables:**
   ```bash
   vercel env add TELEGRAM_BOT_TOKEN
   # Enter your bot token when prompted
   ```

### 🔧 Manual Setup

1. **Connect Repository:**
   - Go to [Vercel Dashboard](https://vercel.com)
   - Click "New Project"
   - Import your GitHub repository

2. **Configure Project:**
   - **Framework Preset:** Python
   - **Root Directory:** `./` (leave default)
   - **Build Command:** `pip install -r requirements.txt`
   - **Output Directory:** `./`

3. **Environment Variables:**
   Add these in Vercel dashboard:
   ```
   TELEGRAM_BOT_TOKEN=your_bot_token_here
   PYTHONPATH=.
   ```

4. **Deploy:**
   - Click "Deploy"
   - Vercel will build and deploy automatically

### 🌐 Webhook Setup

After deployment, set the webhook URL:

1. **Get your Vercel URL** from the deployment dashboard
2. **Set webhook:**
   ```
   https://your-vercel-url.vercel.app/api/webhook
   ```

3. **Or use the API endpoint:**
   ```
   curl "https://your-vercel-url.vercel.app/set_webhook"
   ```

### 📊 Configuration Files

Vercel uses these files:
- `vercel.json` - Vercel configuration
- `api/index.py` - Main serverless function
- `requirements.txt` - Python dependencies

### 🔍 Testing

**Health Check:**
```
curl https://your-vercel-url.vercel.app/
```

**Webhook Test:**
```
curl -X POST https://your-vercel-url.vercel.app/webhook \
  -H "Content-Type: application/json" \
  -d '{"update_id": 1, "message": {"message_id": 1, "text": "/start"}}'
```

### ⚠️ Important Notes

- **Serverless Limits:** Vercel functions have a 30-second timeout
- **Cold Starts:** First request after inactivity may be slower
- **File System:** No persistent file storage between function calls
- **Environment:** Functions run in isolated containers

### 🆘 Troubleshooting

**Function Timeout:**
- Vercel functions are limited to 30 seconds
- Complex operations may need optimization

**Import Errors:**
- Ensure all dependencies are in `requirements.txt`
- Check `PYTHONPATH` is set correctly

**Webhook Issues:**
- Verify the webhook URL is accessible
- Check Telegram bot token is valid
- Use the `/set_webhook` endpoint to configure

### 💡 Pro Tips

- **Development:** Use `vercel dev` for local development
- **Logs:** Check Vercel dashboard for function logs
- **Scaling:** Vercel automatically scales serverless functions
- **Domains:** Custom domains supported

Vercel is great for webhook-based bots and API endpoints!
