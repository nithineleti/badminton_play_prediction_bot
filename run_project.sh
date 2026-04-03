#!/bin/bash
# Complete setup and run script for Badminton Wind Predictor Bot

echo "🎯 Badminton Wind Predictor Bot - Complete Setup & Run"
echo "======================================================"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check Python
if command_exists python3; then
    PYTHON_CMD="python3"
    echo "✅ Python 3 found"
elif command_exists python; then
    PYTHON_CMD="python"
    echo "✅ Python found"
else
    echo "❌ Python not found. Please install Python 3.8+"
    exit 1
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    $PYTHON_CMD -m venv venv
fi

# Activate virtual environment
echo "🔄 Activating virtual environment..."
source venv/bin/activate

# Install/update dependencies
echo "📥 Installing dependencies..."
pip install -r requirements.txt

# Generate sample data if not exists
if [ ! -f "data/processed/weather_data.csv" ]; then
    echo "📊 Generating sample weather data..."
    $PYTHON_CMD scripts/make_sample_data.py
fi

# Train model if not exists
if [ ! -f "experiments/latest/model.keras" ]; then
    echo "🧠 Training ML model..."
    $PYTHON_CMD -m src.cli.train --model lstm --epochs 20
fi

# Setup bot token if .env doesn't exist
if [ ! -f ".env" ]; then
    echo "🤖 Setting up bot configuration..."
    cp .env.example .env
    echo ""
    echo "⚠️  IMPORTANT: You need a Telegram bot token!"
    echo "1. Go to Telegram and search for @BotFather"
    echo "2. Send /newbot and follow instructions"
    echo "3. Copy the token and run: ./setup_bot.sh"
    echo ""
    echo "For now, the bot will run in demo mode."
fi

# Start the bot
echo "🚀 Starting Telegram bot..."
echo "Press Ctrl+C to stop"
echo ""
$PYTHON_CMD -m src.integrations.telegram_bot
