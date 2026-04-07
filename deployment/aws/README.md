# AWS Elastic Beanstalk Deployment Guide

Deploy your Badminton Wind Predictor Bot to AWS using Elastic Beanstalk.

## 🚀 One-Command Deployment (Recommended)

From the project root directory:

```bash
# Full automated setup and deployment
./setup_aws.sh --full

# Or step by step:
./setup_aws.sh --prereqs    # Install prerequisites
./setup_aws.sh --aws        # Configure AWS
./setup_aws.sh --deploy     # Deploy to AWS
```

## 📋 What the Script Does

### 1. Prerequisites Installation
- ✅ Python 3.10+
- ✅ AWS CLI v2
- ✅ Elastic Beanstalk CLI
- ✅ Required system packages

### 2. AWS Configuration
- ✅ AWS credentials setup
- ✅ IAM role creation for Elastic Beanstalk
- ✅ Instance profile configuration

### 3. Application Deployment
- ✅ Elastic Beanstalk application creation
- ✅ Environment setup (t3.micro instance)
- ✅ Application deployment
- ✅ Environment variable configuration
- ✅ Health checks and testing

## 🔧 Manual Setup (Alternative)

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
eb create badminton-bot-env --instance-type t3.micro --single
```

### 3. Deploy
```bash
eb deploy
```

### 4. Set Environment Variables
```bash
eb setenv TELEGRAM_BOT_TOKEN=your_bot_token_here
eb setenv WEATHER_API_KEY=your_weather_api_key_here  # Optional
```

## 📁 Files Structure

```
deployment/aws/
├── .ebextensions/
│   └── environment.config    # EB configuration
├── .platform/
│   └── hooks/
│       └── predeploy/
│           └── setup_bot.sh  # Pre-deployment setup
├── Procfile                  # EB process definition
├── requirements.txt          # Python dependencies
├── application.py           # Flask app with bot integration
└── deploy.sh               # Deployment script
```

## 🔧 Configuration

### Environment Variables
- `TELEGRAM_BOT_TOKEN`: Your Telegram bot token (required)
- `WEATHER_API_KEY`: OpenWeatherMap API key (optional)
- `PYTHONPATH`: Automatically set to `/var/app/current`

### Instance Type
- **Free Tier:** t3.micro (750 hours/month)
- **Production:** t3.small or larger

### Application Features
- **Flask Web Server** with Telegram bot integration
- **Health Check Endpoints** (`/health`, `/info`)
- **Webhook Support** (optional)
- **Background Bot Processing** with threading
- **Auto-scaling Ready**

## 🌐 Access Your Bot

After deployment, your application will be available at:
```
http://badminton-bot-env.eba-xxxxxxxx.us-east-1.elasticbeanstalk.com
```

### Health Check
```
GET /health  # Application health status
GET /info    # Bot information and weather data
```

## 🛠️ Management Commands

```bash
# Check status
eb status

# View application logs
eb logs --all

# SSH into EC2 instance
eb ssh

# Update deployment
eb deploy

# Scale the application
eb scale 2  # Scale to 2 instances

# Terminate environment
eb terminate badminton-bot-env
```

## � Cost Estimate

### Free Tier (First 12 months)
- **EC2 t3.micro:** 750 hours free
- **Elastic Load Balancer:** 750 hours free
- **Data Transfer:** 100 GB free

### After Free Tier
- **EC2 t3.micro:** ~$8.50/month
- **Elastic Load Balancer:** ~$15/month
- **Data Transfer:** Free for most bot traffic

## 🔄 Updates

```bash
# Make changes to your code
# Then deploy updates
eb deploy
```

## 🐛 Troubleshooting

### Bot Not Responding
```bash
eb logs --all
eb ssh
# Check logs in /var/app/current/logs/
```

### Environment Issues
```bash
eb config                    # View configuration
eb setenv VARIABLE=value     # Update environment variables
eb health                    # Check instance health
```

### Permission Issues
Ensure your AWS user has these permissions:
- `elasticbeanstalk:*`
- `ec2:*`
- `iam:*`
- `cloudformation:*`

## 🔒 Security Notes

- Bot token is stored as environment variable
- No sensitive data in application logs
- AWS security groups restrict access
- Regular security updates via Elastic Beanstalk

---

*AWS Elastic Beanstalk provides managed infrastructure with automatic scaling, monitoring, and security updates.*
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
