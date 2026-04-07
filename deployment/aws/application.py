#!/usr/bin/env python3
"""
AWS Elastic Beanstalk application for Badminton Wind Predictor Bot.
Supports both webhook mode and polling mode for Telegram bot.
"""

import os
import sys
import logging
from flask import Flask, request, jsonify
from telegram import Update
from telegram.ext import Application, CommandHandler, CallbackQueryHandler, MessageHandler, filters
import asyncio
import threading
import time

# Add src to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..'))

from src.integrations.telegram_bot import (
    start, predict, button_handler, full_forecast,
    change_location, main_menu, get_cached_weather,
    DEFAULT_LOCATION, RANDOM_SEED
)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Initialize Flask app
app = Flask(__name__)

# Global variables
bot_app = None
bot_thread = None

def create_bot_application():
    """Create and configure the Telegram bot application."""
    global bot_app

    token = os.environ.get('TELEGRAM_BOT_TOKEN')
    if not token:
        logger.error("TELEGRAM_BOT_TOKEN not found in environment variables")
        return None

    try:
        # Create application
        bot_app = Application.builder().token(token).build()

        # Add handlers
        bot_app.add_handler(CommandHandler("start", start))
        bot_app.add_handler(CallbackQueryHandler(button_handler))
        bot_app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, predict))

        logger.info("Bot application created successfully")
        return bot_app

    except Exception as e:
        logger.error(f"Failed to create bot application: {e}")
        return None

def run_bot():
    """Run the bot in polling mode."""
    global bot_app

    if not bot_app:
        logger.error("Bot application not initialized")
        return

    try:
        logger.info("Starting bot in polling mode...")
        bot_app.run_polling(allowed_updates=Update.ALL_TYPES)
    except Exception as e:
        logger.error(f"Error running bot: {e}")

def start_bot_thread():
    """Start the bot in a separate thread."""
    global bot_thread

    if bot_thread and bot_thread.is_alive():
        logger.info("Bot thread already running")
        return

    bot_thread = threading.Thread(target=run_bot, daemon=True)
    bot_thread.start()
    logger.info("Bot thread started")

@app.route('/')
def home():
    """Health check endpoint."""
    return jsonify({
        "status": "running",
        "bot": "Badminton Wind Predictor",
        "location": DEFAULT_LOCATION,
        "version": "1.0.0"
    })

@app.route('/health')
def health():
    """Detailed health check."""
    try:
        # Test weather API
        weather_data = get_cached_weather(DEFAULT_LOCATION)
        weather_status = "OK"
    except Exception as e:
        weather_status = f"ERROR: {str(e)}"

    # Check bot status
    bot_status = "RUNNING" if bot_thread and bot_thread.is_alive() else "STOPPED"

    return jsonify({
        "status": "healthy" if weather_status == "OK" and bot_status == "RUNNING" else "unhealthy",
        "bot_status": bot_status,
        "weather_api": weather_status,
        "location": DEFAULT_LOCATION,
        "timestamp": time.time()
    })

@app.route('/webhook', methods=['POST'])
def webhook():
    """Handle Telegram webhooks (optional alternative to polling)."""
    if not bot_app:
        return jsonify({"error": "Bot not initialized"}), 500

    try:
        data = request.get_json()
        update = Update.de_json(data, bot_app.bot)

        # Process update asynchronously
        asyncio.run(bot_app.process_update(update))

        return jsonify({"status": "ok"}), 200

    except Exception as e:
        logger.error(f"Webhook error: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/set_webhook', methods=['GET'])
def set_webhook():
    """Set webhook URL for Telegram (optional)."""
    if not bot_app:
        return jsonify({"error": "Bot not initialized"}), 500

    webhook_url = os.environ.get('WEBHOOK_URL')
    if not webhook_url:
        return jsonify({"error": "WEBHOOK_URL not set"}), 400

    try:
        success = asyncio.run(bot_app.bot.set_webhook(webhook_url + '/webhook'))
        return jsonify({"webhook_set": success, "url": webhook_url + '/webhook'})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/info')
def info():
    """Get bot information and current weather."""
    try:
        weather_data = get_cached_weather(DEFAULT_LOCATION)

        return jsonify({
            "bot_name": "Badminton Wind Predictor",
            "location": DEFAULT_LOCATION,
            "current_weather": {
                "wind_speed": weather_data['current_wind'],
                "temperature": weather_data['temperature'],
                "humidity": weather_data['humidity'],
                "last_updated": weather_data['updated'].isoformat()
            },
            "playable": weather_data['current_wind'] <= 3.33
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    # Initialize bot
    create_bot_application()

    # Start bot in polling mode (for development/testing)
    if os.environ.get('FLASK_ENV') == 'development':
        start_bot_thread()

    # Run Flask app
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
