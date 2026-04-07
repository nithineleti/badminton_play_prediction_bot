#!/bin/bash
# Complete AWS Elastic Beanstalk Deployment Script for Badminton Bot
# This script handles the entire deployment process automatically

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Complete AWS Deployment for Badminton Wind Predictor Bot${NC}"
echo "======================================================"

# Function to check command existence
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}❌ $1 is not installed. Please install it first.${NC}"
        echo -e "${YELLOW}Installation instructions:${NC}"
        case "$1" in
            "aws")
                echo "  curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\""
                echo "  unzip awscliv2.zip"
                echo "  sudo ./aws/install"
                ;;
            "eb")
                echo "  pip install awsebcli"
                ;;
            "python3")
                echo "  sudo apt-get install python3 python3-pip  # Ubuntu/Debian"
                echo "  # or"
                echo "  brew install python3  # macOS"
                ;;
        esac
        exit 1
    fi
}

# Check prerequisites
echo -e "${YELLOW}📋 Checking prerequisites...${NC}"
check_command "python3"
check_command "pip"
check_command "aws"
check_command "eb"

# Check AWS credentials
echo -e "${YELLOW}🔐 Checking AWS credentials...${NC}"
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}❌ AWS credentials not configured.${NC}"
    echo -e "${YELLOW}Please run:${NC}"
    echo "  aws configure"
    echo ""
    echo "You'll need:"
    echo "  - AWS Access Key ID"
    echo "  - AWS Secret Access Key"
    echo "  - Default region (us-east-1 recommended)"
    echo "  - Default output format (json)"
    exit 1
fi

echo -e "${GREEN}✅ AWS credentials configured${NC}"

# Get user input for configuration
echo ""
echo -e "${BLUE}🔧 Configuration${NC}"
read -p "Enter your Telegram Bot Token: " BOT_TOKEN
if [ -z "$BOT_TOKEN" ]; then
    echo -e "${RED}❌ Bot token is required${NC}"
    exit 1
fi

read -p "Enter your OpenWeatherMap API Key (optional, press Enter to skip): " WEATHER_KEY
read -p "Choose AWS region [us-east-1]: " AWS_REGION
AWS_REGION=${AWS_REGION:-us-east-1}

read -p "Choose instance type [t3.micro]: " INSTANCE_TYPE
INSTANCE_TYPE=${INSTANCE_TYPE:-t3.micro}

# Set application name
APP_NAME="badminton-bot"
ENV_NAME="${APP_NAME}-env"

echo ""
echo -e "${BLUE}📝 Deployment Configuration:${NC}"
echo "  Application Name: $APP_NAME"
echo "  Environment Name: $ENV_NAME"
echo "  Region: $AWS_REGION"
echo "  Instance Type: $INSTANCE_TYPE"
echo "  Bot Token: ${BOT_TOKEN:0:10}..."
echo "  Weather API: ${WEATHER_KEY:+Configured}"

# Confirm deployment
echo ""
read -p "Continue with deployment? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Deployment cancelled${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}🏗️ Starting AWS Elastic Beanstalk Deployment${NC}"
echo "==============================================="

# Initialize EB application if not exists
if [ ! -d ".elasticbeanstalk" ]; then
    echo -e "${YELLOW}📝 Initializing Elastic Beanstalk application...${NC}"
    eb init "$APP_NAME" \
        --platform "64bit Amazon Linux 2023 v4.12.0 running Python 3.9" \
        --region "$AWS_REGION" \
        --tags "Project=BadmintonBot,Environment=Production"

    echo -e "${GREEN}✅ Application initialized${NC}"
else
    echo -e "${GREEN}ℹ️ Application already initialized${NC}"
fi

# Check if environment exists
ENV_EXISTS=$(eb list 2>/dev/null | grep "$ENV_NAME" || echo "")

if [ -z "$ENV_EXISTS" ]; then
    echo -e "${YELLOW}🏗️ Creating environment '$ENV_NAME'...${NC}"
    eb create "$ENV_NAME" \
        --instance-type "$INSTANCE_TYPE" \
        --single \
        --tags "Project=BadmintonBot,Environment=Production"

    echo -e "${GREEN}✅ Environment created${NC}"
else
    echo -e "${GREEN}ℹ️ Environment '$ENV_NAME' already exists${NC}"
fi

# Deploy the application
echo -e "${YELLOW}🚀 Deploying application...${NC}"
eb deploy

echo -e "${GREEN}✅ Application deployed${NC}"

# Set environment variables
echo -e "${YELLOW}🔧 Configuring environment variables...${NC}"
eb setenv TELEGRAM_BOT_TOKEN="$BOT_TOKEN"
echo -e "${GREEN}✅ Bot token configured${NC}"

if [ ! -z "$WEATHER_KEY" ]; then
    eb setenv WEATHER_API_KEY="$WEATHER_KEY"
    echo -e "${GREEN}✅ Weather API key configured${NC}"
fi

# Set PYTHONPATH
eb setenv PYTHONPATH="/var/app/current"
echo -e "${GREEN}✅ Python path configured${NC}"

# Get application status and URL
echo ""
echo -e "${BLUE}📊 Deployment Status${NC}"
echo "=================="
eb status

# Wait a moment for the environment to be ready
echo ""
echo -e "${YELLOW}⏳ Waiting for environment to be ready...${NC}"
sleep 30

# Test the application
echo -e "${YELLOW}🧪 Testing application health...${NC}"
HEALTH_URL=$(eb status | grep -o "http://[^ ]*\.elasticbeanstalk\.com")
if [ ! -z "$HEALTH_URL" ]; then
    HEALTH_CHECK=$(curl -s -o /dev/null -w "%{http_code}" "${HEALTH_URL}/health" 2>/dev/null || echo "000")
    if [ "$HEALTH_CHECK" = "200" ]; then
        echo -e "${GREEN}✅ Application is healthy${NC}"
    else
        echo -e "${YELLOW}⚠️ Health check returned status $HEALTH_CHECK${NC}"
    fi
fi

echo ""
echo -e "${GREEN}🎉 Deployment Complete!${NC}"
echo "========================"
echo ""
echo -e "${BLUE}🌐 Your bot is now running at:${NC}"
eb status | grep "http"
echo ""
echo -e "${BLUE}🛠️ Useful Commands:${NC}"
echo "  Check status:    eb status"
echo "  View logs:       eb logs"
echo "  SSH access:      eb ssh"
echo "  Update app:      eb deploy"
echo "  Scale up:        eb scale 2"
echo ""
echo -e "${BLUE}💰 Cost Monitoring:${NC}"
echo "  Your t3.micro instance is eligible for the AWS free tier (750 hours/month)"
echo "  Monitor costs at: https://console.aws.amazon.com/billing"
echo ""
echo -e "${GREEN}🚀 Your badminton prediction bot is ready to use!${NC}"
