#!/bin/bash
# AWS Elastic Beanstalk pre-deployment hook
# Sets up the badminton bot environment

echo "Setting up Badminton Wind Predictor Bot..."

# Ensure proper permissions
chmod +x /var/app/current/application.py

# Create necessary directories
mkdir -p /var/app/current/logs
mkdir -p /var/app/current/data

# Set environment variables if not already set
if [ -z "$TELEGRAM_BOT_TOKEN" ]; then
    echo "Warning: TELEGRAM_BOT_TOKEN not set"
fi

# Verify Python dependencies
python3 -c "import flask, telegram; print('Dependencies OK')" || echo "Warning: Some dependencies may be missing"

echo "Bot setup complete"
