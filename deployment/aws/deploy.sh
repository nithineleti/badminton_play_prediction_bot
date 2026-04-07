#!/bin/bash
# AWS Elastic Beanstalk Deployment Script
# Run this from the deployment/aws directory

set -e

echo "🚀 Deploying Badminton Wind Predictor to AWS Elastic Beanstalk"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not found. Please install it first:"
    echo "   pip install awscli"
    exit 1
fi

# Check if EB CLI is installed
if ! command -v eb &> /dev/null; then
    echo "❌ EB CLI not found. Please install it first:"
    echo "   pip install awsebcli"
    exit 1
fi

# Check if user is logged in
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ Not logged in to AWS. Please run:"
    echo "   aws configure"
    exit 1
fi

# Initialize EB if not already done
if [ ! -d ".elasticbeanstalk" ]; then
    echo "📝 Initializing Elastic Beanstalk..."
    eb init badminton-bot \
        --platform "Python 3.10 running on 64bit Amazon Linux 2" \
        --region us-east-1

    echo "✅ Elastic Beanstalk initialized"
fi

# Create environment if it doesn't exist
if ! eb list | grep -q "badminton-bot-env"; then
    echo "🏗️ Creating environment..."
    eb create badminton-bot-env \
        --instance-type t3.micro \
        --single

    echo "✅ Environment created"
else
    echo "📦 Environment already exists, deploying updates..."
fi

# Deploy the application
echo "🚀 Deploying application..."
eb deploy

# Set environment variables (you'll need to replace with actual values)
echo "🔧 Setting environment variables..."
echo "Please set your TELEGRAM_BOT_TOKEN:"
read -p "Enter your Telegram bot token: " bot_token
eb setenv TELEGRAM_BOT_TOKEN="$bot_token"

echo "🌐 Optional: Set WEATHER_API_KEY for enhanced weather data"
read -p "Enter your OpenWeatherMap API key (or press Enter to skip): " weather_key
if [ ! -z "$weather_key" ]; then
    eb setenv WEATHER_API_KEY="$weather_key"
fi

# Get the application URL
echo "📍 Getting application URL..."
eb status

echo ""
echo "🎉 Deployment complete!"
echo "Your bot should be running at the URL shown above"
echo ""
echo "To check logs: eb logs"
echo "To SSH into instance: eb ssh"
echo "To update: make changes and run 'eb deploy'"
