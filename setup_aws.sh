#!/bin/bash
# AWS Setup and Deployment Script for Badminton Bot
# This script handles everything needed to deploy to AWS

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Complete AWS Setup & Deployment for Badminton Bot${NC}"
echo "======================================================"

# Function to check and install prerequisites
install_prerequisites() {
    echo -e "${YELLOW}📦 Installing prerequisites...${NC}"

    # Detect OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        PACKAGE_MANAGER="apt-get"
        if command -v yum &> /dev/null; then
            PACKAGE_MANAGER="yum"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PACKAGE_MANAGER="brew"
    else
        echo -e "${RED}❌ Unsupported OS: $OSTYPE${NC}"
        exit 1
    fi

    echo -e "${BLUE}Detected OS: $OS${NC}"

    # Install Python if not present
    if ! command -v python3 &> /dev/null; then
        echo -e "${YELLOW}Installing Python 3...${NC}"
        if [ "$OS" = "linux" ]; then
            sudo $PACKAGE_MANAGER update
            sudo $PACKAGE_MANAGER install -y python3 python3-pip python3-venv
        elif [ "$OS" = "macos" ]; then
            if ! command -v brew &> /dev/null; then
                echo -e "${RED}Homebrew not found. Please install it first: https://brew.sh/${NC}"
                exit 1
            fi
            brew install python3
        fi
    fi

    # Install AWS CLI
    if ! command -v aws &> /dev/null; then
        echo -e "${YELLOW}Installing AWS CLI...${NC}"
        if [ "$OS" = "linux" ]; then
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
            unzip awscliv2.zip
            sudo ./aws/install
            rm -rf aws awscliv2.zip
        elif [ "$OS" = "macos" ]; then
            curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
            sudo installer -pkg AWSCLIV2.pkg -target /
            rm AWSCLIV2.pkg
        fi
    fi

    # Install EB CLI
    if ! command -v eb &> /dev/null; then
        echo -e "${YELLOW}Installing Elastic Beanstalk CLI...${NC}"
        python3 -m pip install awsebcli
    fi

    echo -e "${GREEN}✅ Prerequisites installed${NC}"
}

# Function to configure AWS
configure_aws() {
    echo -e "${YELLOW}🔐 Configuring AWS credentials...${NC}"

    if ! aws sts get-caller-identity &> /dev/null; then
        echo ""
        echo -e "${BLUE}AWS Configuration Required${NC}"
        echo "You'll need to create an AWS account and get credentials:"
        echo ""
        echo "1. Go to: https://aws.amazon.com/free"
        echo "2. Create a free account"
        echo "3. Go to IAM Console: https://console.aws.amazon.com/iam"
        echo "4. Create a user with programmatic access"
        echo "5. Attach 'AdministratorAccess' policy (for simplicity)"
        echo "6. Get Access Key ID and Secret Access Key"
        echo ""

        aws configure

        if ! aws sts get-caller-identity &> /dev/null; then
            echo -e "${RED}❌ AWS configuration failed${NC}"
            exit 1
        fi
    fi

    echo -e "${GREEN}✅ AWS configured${NC}"
}

# Function to check/create IAM role
setup_iam_role() {
    echo -e "${YELLOW}🔑 Setting up IAM role for Elastic Beanstalk...${NC}"

    ROLE_NAME="aws-elasticbeanstalk-ec2-role"
    INSTANCE_PROFILE_NAME="aws-elasticbeanstalk-ec2-role"

    # Check if role exists
    if ! aws iam get-role --role-name "$ROLE_NAME" &> /dev/null; then
        echo -e "${YELLOW}Creating IAM role...${NC}"

        # Create trust policy
        cat > trust-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

        # Create role
        aws iam create-role \
            --role-name "$ROLE_NAME" \
            --assume-role-policy-document file://trust-policy.json

        # Attach managed policies
        aws iam attach-role-policy \
            --role-name "$ROLE_NAME" \
            --policy-arn "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"

        aws iam attach-role-policy \
            --role-name "$ROLE_NAME" \
            --policy-arn "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"

        aws iam attach-role-policy \
            --role-name "$ROLE_NAME" \
            --policy-arn "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"

        # Create instance profile
        aws iam create-instance-profile --instance-profile-name "$INSTANCE_PROFILE_NAME"
        aws iam add-role-to-instance-profile \
            --instance-profile-name "$INSTANCE_PROFILE_NAME" \
            --role-name "$ROLE_NAME"

        # Clean up
        rm trust-policy.json

        echo -e "${GREEN}✅ IAM role created${NC}"
    else
        echo -e "${GREEN}ℹ️ IAM role already exists${NC}"
    fi
}

# Main deployment function
main_deployment() {
    echo ""
    echo -e "${BLUE}🏗️ Starting Deployment Process${NC}"
    echo "============================="

    # Change to AWS deployment directory
    cd deployment/aws

    # Run the deployment script
    chmod +x deploy.sh
    ./deploy.sh
}

# Main menu
show_menu() {
    echo ""
    echo -e "${BLUE}Select deployment option:${NC}"
    echo "1) 🚀 Full automated setup and deployment"
    echo "2) 📦 Install prerequisites only"
    echo "3) 🔐 Configure AWS only"
    echo "4) 🏗️ Deploy (assumes prerequisites are ready)"
    echo "5) ❌ Exit"
    echo ""
    read -p "Enter your choice (1-5): " choice
}

# Main script
case "${1:-}" in
    "--full"|"-f")
        echo -e "${GREEN}Starting full automated deployment...${NC}"
        install_prerequisites
        configure_aws
        setup_iam_role
        main_deployment
        ;;
    "--prereqs"|"-p")
        install_prerequisites
        ;;
    "--aws"|"-a")
        configure_aws
        ;;
    "--deploy"|"-d")
        main_deployment
        ;;
    *)
        show_menu
        case $choice in
            1)
                install_prerequisites
                configure_aws
                setup_iam_role
                main_deployment
                ;;
            2)
                install_prerequisites
                ;;
            3)
                configure_aws
                ;;
            4)
                main_deployment
                ;;
            5)
                echo -e "${YELLOW}Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                exit 1
                ;;
        esac
        ;;
esac

echo ""
echo -e "${GREEN}🎉 Setup complete! Your badminton bot is now running on AWS.${NC}"
