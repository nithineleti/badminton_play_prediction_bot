import os
import sys
from flask import Flask, request, jsonify
from telegram import Update
from telegram.ext import Application, CommandHandler, CallbackQueryHandler, MessageHandler, filters
import asyncio
import logging

# Add src to path
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from src.integrations.telegram_bot import (
    start, predict, button_handler, full_forecast,
    change_location, main_menu, get_cached_weather,
    DEFAULT_LOCATION, RANDOM_SEED
)

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize Flask app
app = Flask(__name__)

# Global variable to store the bot application
bot_app = None

async def initialize_bot():
    """Initialize the Telegram bot application."""
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

        logger.info("Bot initialized successfully")
        return bot_app

    except Exception as e:
        logger.error(f"Failed to initialize bot: {e}")
        return None

@app.route('/', methods=['GET'])
def home():
    """Health check endpoint."""
    return jsonify({
        "status": "ok",
        "message": "Badminton Wind Predictor Bot API",
        "endpoints": {
            "webhook": "/webhook",
            "health": "/"
        }
    })

@app.route('/webhook', methods=['POST'])
async def webhook():
    """Handle Telegram webhook updates."""
    global bot_app

    if not bot_app:
        bot_app = await initialize_bot()
        if not bot_app:
            return jsonify({"error": "Bot initialization failed"}), 500

    try:
        # Get the update from Telegram
        update_data = request.get_json()
        if not update_data:
            return jsonify({"error": "No update data"}), 400

        # Create Update object
        update = Update.de_json(update_data, bot_app.bot)

        # Process the update
        await bot_app.process_update(update)

        return jsonify({"status": "ok"}), 200

    except Exception as e:
        logger.error(f"Error processing webhook: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/set_webhook', methods=['GET'])
async def set_webhook():
    """Set the webhook URL for Telegram."""
    global bot_app

    if not bot_app:
        bot_app = await initialize_bot()
        if not bot_app:
            return jsonify({"error": "Bot initialization failed"}), 500

    try:
        # Get Vercel URL from environment or request headers
        vercel_url = os.environ.get('VERCEL_URL')
        if not vercel_url:
            # Try to get from request headers (for local development)
            vercel_url = request.headers.get('host')
            if vercel_url:
                vercel_url = f"https://{vercel_url}"

        if not vercel_url:
            return jsonify({"error": "VERCEL_URL not found"}), 500

        webhook_url = f"{vercel_url}/api/webhook"

        # Set webhook
        await bot_app.bot.set_webhook(url=webhook_url)

        return jsonify({
            "status": "ok",
            "message": f"Webhook set to {webhook_url}"
        }), 200

    except Exception as e:
        logger.error(f"Error setting webhook: {e}")
        return jsonify({"error": str(e)}), 500

# Initialize bot on startup
@app.before_request
async def startup():
    """Initialize bot on first request."""
    global bot_app
    if not bot_app:
        await initialize_bot()

if __name__ == '__main__':
    # For local development
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
