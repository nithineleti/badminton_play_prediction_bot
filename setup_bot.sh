#!/bin/bash
# Setup script for Telegram bot token

echo "🤖 Badminton Wind Predictor Bot Setup"
echo "====================================="
echo ""

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found!"
    exit 1
fi

echo "Current .env file:"
echo "------------------"
cat .env
echo ""
echo "📝 To get a Telegram bot token:"
echo "1. Open Telegram"
echo "2. Search for @BotFather"
echo "3. Send /newbot"
echo "4. Follow the instructions to create your bot"
echo "5. Copy the token BotFather gives you"
echo ""

read -p "Do you have a bot token ready? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    read -p "Enter your Telegram bot token: " token

    if [ -n "$token" ]; then
        # Update the .env file
        sed -i.bak "s/TELEGRAM_BOT_TOKEN=.*/TELEGRAM_BOT_TOKEN=$token/" .env
        echo ""
        echo "✅ Token updated in .env file!"
        echo ""
        echo "🚀 Ready to run the bot!"
        echo "Command: /Library/Frameworks/Python.framework/Versions/3.13/bin/python3 -m src.integrations.telegram_bot"
        echo ""
        echo "The bot will start and connect to Telegram."
        echo "Users can find your bot by searching for the username you created with BotFather."
    else
        echo "❌ No token entered."
    fi
else
    echo ""
    echo "ℹ️  When you have your token, run this script again or manually edit the .env file."
    echo "The demo mode is working - you can test functionality without a real token."
fi
