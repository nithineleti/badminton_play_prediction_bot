# 🏸 Badminton Wind Predictor

A web application that predicts whether it's safe to play badminton outdoors based on current wind conditions.

## Features

- 🌤️ **Real-time Weather Data**: Fetches live weather data from weather APIs
- 🏸 **Smart Predictions**: Determines if wind conditions are safe for badminton
- 📊 **Detailed Forecasts**: Shows wind predictions for the next 1, 3, and 6 hours
- 🎯 **Safety Guidelines**: Clear recommendations based on wind speed thresholds
- 🔄 **Auto-updates**: Data refreshes every 5 minutes for consistency

## How It Works

The app analyzes wind speed and gust data to determine playability:

- 🟢 **Safe**: Wind ≤ 3.33 m/s
- 🟡 **Marginal**: Wind 3.33-4.0 m/s
- 🔴 **Unsafe**: Wind > 4.0 m/s

## Location

Currently configured for **IIIT Lucknow** location. The app uses cached weather data to ensure consistent predictions.

## Tech Stack

- **Gradio**: Web interface framework
- **Pandas**: Data processing
- **NumPy**: Numerical computations
- **Requests**: API calls for weather data
- **Python-Telegram-Bot**: Bot integration (for reference)

## Usage

Simply click the "🌤️ Check Current Conditions" button to get the latest wind prediction and safety assessment for badminton play.

---

*Built with ❤️ for badminton enthusiasts*</content>
<parameter name="filePath">/Users/nithineleti/Downloads/PROJECTS/badminton_play_prediction_bot/deployment/hf_space/README.md
