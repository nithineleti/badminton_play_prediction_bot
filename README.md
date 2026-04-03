# 🏸 Badminton Wind Predictor - predict_air_bot

A complete, end-to-end machine learning system for predicting short-term wind conditions (1h/3h/6h) and deciding whether it's safe to play badminton outdoors. Features a **Telegram bot with interactive UI**, synthetic data generation, LSTM forecasting, and a decision engine with configurable thresholds.

## ✨ Features

- ⚡ **One-Command Setup**: `./run_project.sh` handles everything automatically
- 🤖 **Interactive Telegram Bot**: Buttons for refresh, main menu, location change, full forecast
- 🔄 **Consistent Predictions**: Weather data caching prevents alternating results
- 🆓 **Zero-Cost**: Uses synthetic data, runs on free tiers
- 🚀 **Deployment-Ready**: Railway, Render, Fly.io, and Hugging Face Spaces support
- 📊 **Reproducible**: Deterministic RNG and pinned dependencies
- � **Well-Tested**: Unit tests and CI with GitHub Actions
- 📱 **Mobile-Friendly**: Telegram bot works perfectly on phones

## 🎯 Quick Start (Local)

### Option 1: One-Command Setup (Recommended)

```bash
# Clone and run - that's it!
git clone <repository-url>
cd badminton_play_prediction_bot
chmod +x run_project.sh
./run_project.sh
```

The script automatically:
- ✅ Creates virtual environment
- ✅ Installs all dependencies
- ✅ Generates sample weather data
- ✅ Trains ML model (if needed)
- ✅ Sets up bot configuration
- ✅ Starts the Telegram bot

### Option 2: Manual Setup

```bash
# 1. Setup environment
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 2. Install dependencies
pip install -r requirements.txt

# 3. Generate sample data
python scripts/make_sample_data.py

# 4. Train model (optional - bot works without it)
python -m src.cli.train --model lstm --epochs 20

# 5. Setup bot token
./setup_bot.sh

# 6. Run the bot
python -m src.integrations.telegram_bot
```

### Option 3: Using Make Commands

```bash
make setup      # Create virtual environment
make data       # Generate sample data
make train      # Train ML model
make test       # Run tests
make ui         # Launch Gradio UI
```

## 🤖 Telegram Bot Setup

**Bot Name:** `@predict_air_bot`  
**Token:** `8673843397:AAHzVeeFGuOZVztMBpnUUjSzD6G5jYHdJuQ` ⚠️ *Keep secure!*

### First-Time Bot Setup

1. **Get Telegram Token** (one-time):
   - Open Telegram → Search `@BotFather`
   - Send `/newbot` → Follow instructions
   - Copy the token

2. **Configure Token**:
   ```bash
   ./setup_bot.sh
   # Paste your token when prompted
   ```

3. **Start Bot**:
   ```bash
   ./run_project.sh
   # Or manually: python -m src.integrations.telegram_bot
   ```

### 🤖 Bot Features

**Interactive Commands:**
- `/start` - Welcome message with main menu
- **🌤️ Quick Check** - Instant play/don't play decision
- **🔄 Refresh** - Get fresh weather data
- **🏠 Main Menu** - Return to main menu
- **📍 Change Location** - Location settings (future feature)
- **🔮 Full Forecast** - Detailed 6-hour wind forecast

**Smart Features:**
- ✅ **Consistent Results** - Weather caching prevents alternating predictions
- ✅ **Real-time Updates** - Fresh data every 5 minutes
- ✅ **Mobile Optimized** - Works perfectly on phones
- ✅ **Error Handling** - Graceful fallbacks and user-friendly messages

**How to Use:**
1. Start a chat with `@predict_air_bot` on Telegram
2. Send `/start` or click the buttons
3. Get instant badminton playing recommendations!

## 📁 Project Structure

```
badminton_play_prediction_bot/
├── run_project.sh           # 🆕 One-command setup script
├── start.sh                 # Railway deployment script
├── setup_bot.sh            # Bot token configuration
├── requirements.txt         # Python dependencies
├── requirements-bots.txt   # Bot-specific dependencies
├── .env                     # Environment variables (bot token)
├── .env.example            # Environment template
├── pyproject.toml          # Project configuration
├── environment.yml         # Conda environment
├── runtime.txt             # Python version for deployment
├── Makefile                # Build automation
├── README.md               # This file
├── src/
│   ├── config.py           # Central configuration
│   ├── data/
│   │   ├── fetch.py        # Data loading utilities
│   │   └── preprocess.py   # Feature engineering
│   ├── models/
│   │   ├── baseline.py     # Persistence model
│   │   ├── lstm_model.py   # LSTM forecaster
│   │   └── quantiles.py    # Uncertainty quantification
│   ├── eval/
│   │   ├── metrics.py      # MAE, RMSE, quantile loss
│   │   └── backtest.py     # Rolling-window validation
│   ├── decision/
│   │   ├── rules.py        # Play/Don't Play logic
│   │   └── thresholds.json # Decision thresholds
│   ├── integrations/
│   │   └── telegram_bot.py # 🤖 Main Telegram bot
│   ├── utils/
│   │   └── io.py           # I/O helpers
│   └── cli/
│       ├── train.py        # Training CLI
│       └── infer.py        # Inference CLI
├── scripts/
│   ├── make_sample_data.py # Generate synthetic weather data
│   └── run_all.sh          # End-to-end pipeline
├── data/
│   ├── processed/          # Processed datasets
│   └── raw/                # Raw data (gitignored)
├── experiments/
│   └── latest/             # Model artifacts (gitignored)
├── tests/                  # Unit tests
├── deployment/             # Deployment configurations
│   ├── hf_space/          # Hugging Face Spaces
│   ├── railway/           # Railway deployment
│   └── render/            # Render deployment
├── notebooks/             # Jupyter notebooks
├── docs/                  # Documentation
└── .github/               # GitHub Actions CI/CD
```

## 🚀 Deployment Options

### Railway (Recommended - 100% Free)

```bash
# Automatic deployment
git push to Railway remote
# That's it! Railway handles everything
```

### Render

```yaml
# render.yaml
services:
  - type: web
    name: badminton-bot
    env: python
    buildCommand: "pip install -r requirements.txt && python scripts/make_sample_data.py"
    startCommand: "python -m src.integrations.telegram_bot"
```

### Fly.io

```toml
# fly.toml
app = "badminton-bot"
primary_region = "sin"

[build]
  image = "python:3.13-slim"

[processes]
  app = "python -m src.integrations.telegram_bot"
```

### Hugging Face Spaces

```bash
# Deploy Gradio UI
cd deployment/hf_space
# Upload to HF Spaces
```

## ⚙️ Configuration

### Bot Settings (`src/config.py`)

```python
# Forecast horizons (hours)
FORECAST_HORIZONS = [1, 3, 6]

# Weather data cache duration
CACHE_DURATION_MINUTES = 5

# Default location
DEFAULT_LOCATION = "IIIT Lucknow"

# Random seed for consistency
RANDOM_SEED = 42
```

### Decision Thresholds (`src/decision/thresholds.json`)

```json
{
  "median_max_m_s": 3.33,
  "q90_max_m_s": 5.0,
  "prob_over_3m_s_max": 0.3
}
```

### Environment Variables (`.env`)

```bash
# Required
TELEGRAM_BOT_TOKEN=your_bot_token_here

# Optional
WEATHER_API_KEY=your_openweather_api_key
OPENAI_API_KEY=your_openai_key_for_enhanced_features
```

## 🧪 Testing & Development

### Run Tests

```bash
# All tests
pytest

# Fast tests only
pytest -m "not slow"

# With coverage
pytest --cov=src --cov-report=html
```

### Code Quality

```bash
# Format code
black src tests scripts

# Sort imports
isort src tests scripts

# Type checking
mypy src
```

### Manual Testing

```bash
# Test bot locally (without token)
python -m src.integrations.telegram_bot

# Test data generation
python scripts/make_sample_data.py

# Test model training
python -m src.cli.train --model lstm --epochs 5

# Test inference
python -m src.cli.infer --model experiments/latest/model.keras
```

## 📊 Model Performance

### Current Status: ⚠️ Demo Mode (Synthetic Data)

- **Baseline Model**: MAE ~0.3 m/s, RMSE ~0.45 m/s
- **LSTM Model**: MAE ~0.25 m/s, RMSE ~0.38 m/s (after 20 epochs)
- **Data Source**: Synthetic weather data for demonstration

### 🎯 Production-Ready Training

**Option 1: Automatic Data Collection (Recommended)**
- Bot automatically collects weather data during use
- Saved to `data/collected/weather_observations.csv`
- Retrain after 30+ days: `python scripts/check_data_collection.py --retrain`

**Option 2: Historical Weather APIs**
- OpenWeatherMap Historical API (paid)
- METAR weather station data
- Local weather station exports

**Expected Real-World Performance:**
- **MAE**: 0.4-0.6 m/s for 1h forecasts
- **RMSE**: 0.6-0.8 m/s for 1h forecasts
- Performance degrades for longer horizons (3h, 6h)

## 🔧 Troubleshooting

### Bot Won't Start

```bash
# Check if another instance is running
pkill -f telegram_bot

# Verify token
cat .env

# Test without token (demo mode)
python -m src.integrations.telegram_bot
```

### Dependencies Issues

```bash
# Clean reinstall
rm -rf venv
./run_project.sh
```

### Model Training Fails

```bash
# Bot works without ML model
# Check data exists
ls data/processed/

# Regenerate data
python scripts/make_sample_data.py
```

### Inconsistent Predictions

- ✅ **Fixed**: Weather data caching ensures consistent results
- Cache duration: 5 minutes
- Same data returns same prediction

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature-name`
3. Add tests for new functionality
4. Ensure `pytest` passes
5. Submit pull request

## 📄 License

MIT License - see LICENSE file for details.

## 🙏 Citation

```bibtex
@software{badminton_wind_predictor,
  title={Badminton Wind Predictor},
  author={Nithin Eleti},
  year={2026},
  url={https://github.com/nithineleti/badminton_play_prediction_bot}
}
```

## 📞 Support

- **Issues**: Open a GitHub issue
- **Discussions**: Use GitHub Discussions
- **Telegram**: Message `@predict_air_bot` for testing

---

**Ready to predict some badminton weather?** 🏸✨

```bash
./run_project.sh
```
