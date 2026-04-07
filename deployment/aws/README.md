# AWS Elastic Beanstalk Deployment Guide

Deploy your Badminton Wind Predictor Bot to AWS using Elastic Beanstalk.

## 🚀 Quick Deploy

### Prerequisites
- AWS CLI installed and configured
- EB CLI installed (`pip install awsebcli`)

### 1. Initialize Elastic Beanstalk
```bash
cd deployment/aws
eb init badminton-bot --platform python-3.10 --region us-east-1
```

### 2. Create Environment
```bash
eb create badminton-bot-env --instance-type t3.micro
```

### 3. Deploy
```bash
eb deploy
```

### 4. Set Environment Variables
```bash
eb setenv TELEGRAM_BOT_TOKEN=your_bot_token_here
eb setenv WEATHER_API_KEY=your_weather_api_key
```

## 📁 Files Structure

```
deployment/aws/
├── .ebextensions/
│   └── environment.config
├── .platform/
│   └── hooks/
│       └── predeploy/
│           └── setup_bot.sh
├── Procfile
├── requirements.txt
└── application.py
```

## 🔧 Configuration

### Environment Variables
- `TELEGRAM_BOT_TOKEN`: Your Telegram bot token
- `WEATHER_API_KEY`: OpenWeatherMap API key (optional)
- `PYTHONPATH`: Automatically set

### Instance Type
- **Free Tier:** t3.micro (750 hours/month)
- **Production:** t3.small or larger

## 🌐 Access Your Bot

After deployment, your bot will be running on:
```
http://badminton-bot-env.eba-xxxxxxxx.us-east-1.elasticbeanstalk.com
```

## 🛠️ Troubleshooting

### Bot Not Responding
```bash
eb logs --all
eb ssh
# Check bot logs in /var/app/current/
```

### Environment Issues
```bash
eb config
eb setenv VARIABLE_NAME=value
```

## 💰 Cost Estimate

- **EC2 t3.micro:** ~$8.50/month
- **Elastic Load Balancer:** ~$15/month
- **Data Transfer:** Free tier covers most usage

## 🔄 Updates

```bash
# Make changes, then:
eb deploy
```

---

*AWS Elastic Beanstalk provides managed infrastructure with auto-scaling and monitoring.*</content>
<parameter name="filePath">/Users/nithineleti/Downloads/PROJECTS/badminton_play_prediction_bot/deployment/aws/README.md
