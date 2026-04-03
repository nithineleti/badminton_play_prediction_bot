#!/bin/bash
# Startup script for Railway deployment
# This ensures the model exists before starting the bot

echo "🚀 Starting Badminton Wind Bot deployment..."

# Check if model exists
if [ ! -f "experiments/latest/model.keras" ]; then
    echo "⚠️  Model not found. Training a new model..."
    
    # Create sample data
    /Library/Frameworks/Python.framework/Versions/3.13/bin/python3 scripts/make_sample_data.py
    
    # Train model (quick training for deployment)
    /Library/Frameworks/Python.framework/Versions/3.13/bin/python3 -m src.cli.train --model lstm --epochs 20
    
    echo "✅ Model trained successfully!"
else
    echo "✅ Model found at experiments/latest/model.keras"
fi

# Start the bot
echo "🤖 Starting Telegram bot..."
/Library/Frameworks/Python.framework/Versions/3.13/bin/python3 -m src.integrations.telegram_bot
