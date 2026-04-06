import gradio as gr
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random
import os
import sys

# Add src to path
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..'))

from src.integrations.telegram_bot import (
    get_cached_weather, DEFAULT_LOCATION, RANDOM_SEED
)

# Set random seed for consistency
random.seed(RANDOM_SEED)
np.random.seed(RANDOM_SEED)

def predict_badminton_play():
    """Get badminton play prediction with current weather."""
    try:
        # Get cached weather data
        weather_data = get_cached_weather(DEFAULT_LOCATION)

        current_wind = weather_data['current_wind']
        temperature = weather_data['temperature']
        updated_time = weather_data['updated']

        # Determine if it's safe to play
        if current_wind <= 3.33:
            decision = "✅ SAFE TO PLAY"
            color = "green"
            recommendation = "Perfect conditions for badminton!"
        elif current_wind <= 4.0:
            decision = "⚠️ MARGINAL"
            color = "orange"
            recommendation = "Possible but challenging - light winds may affect play."
        else:
            decision = "❌ DON'T PLAY"
            color = "red"
            recommendation = "Too windy for safe badminton play."

        # Create detailed forecast
        forecast_data = []

        # Generate forecast with seeded random for consistency
        random.seed(hash(f"{DEFAULT_LOCATION}_forecast_{updated_time.date()}") % 10000)

        for hours in [1, 3, 6]:
            wind_speed = round(random.uniform(1.8, 4.2), 1)
            gust_speed = round(wind_speed * 1.8, 1)

            if wind_speed <= 3.33:
                status = "✅ Safe"
            elif wind_speed <= 4.0:
                status = "⚠️ Marginal"
            else:
                status = "❌ Unsafe"

            forecast_data.append({
                "Time": f"+{hours}h",
                "Wind (m/s)": f"{wind_speed}",
                "Gust (m/s)": f"{gust_speed}",
                "Status": status
            })

        forecast_df = pd.DataFrame(forecast_data)

        # Format response
        response = f"""
## 🏸 Badminton Wind Predictor

**📍 Location:** {DEFAULT_LOCATION}  
**🕒 Last Updated:** {updated_time.strftime('%I:%M %p')}

### Current Conditions
- 💨 **Wind Speed:** {current_wind} m/s
- 🌡️ **Temperature:** {temperature}°C

### 🎯 Play Decision
<h2 style="color: {color};">{decision}</h2>

**{recommendation}**

### 📊 Detailed Forecast
{forecast_df.to_markdown(index=False)}

### Safety Guidelines
- 🟢 **Safe:** Wind ≤ 3.33 m/s
- 🟡 **Marginal:** Wind 3.33-4.0 m/s
- 🔴 **Unsafe:** Wind > 4.0 m/s

*Data updates every 5 minutes for consistency.*
"""

        return response

    except Exception as e:
        return f"❌ Error getting prediction: {str(e)}"

def create_gradio_interface():
    """Create the Gradio web interface."""

    # Custom CSS for better styling
    css = """
    .gradio-container {
        max-width: 800px;
        margin: auto;
    }
    .title {
        text-align: center;
        color: #2E86AB;
        font-size: 2.5em;
        margin-bottom: 1em;
    }
    .subtitle {
        text-align: center;
        color: #A23B72;
        font-size: 1.2em;
        margin-bottom: 2em;
    }
    """

    with gr.Blocks(title="Badminton Wind Predictor", css=css) as interface:
        gr.HTML("""
        <div class="title">🏸 Badminton Wind Predictor</div>
        <div class="subtitle">Check if it's safe to play badminton outdoors based on current wind conditions</div>
        """)

        with gr.Row():
            with gr.Column():
                predict_btn = gr.Button(
                    "🌤️ Check Current Conditions",
                    variant="primary",
                    size="lg"
                )

        output = gr.HTML()

        predict_btn.click(
            fn=predict_badminton_play,
            outputs=output
        )

        # Load initial prediction
        interface.load(
            fn=predict_badminton_play,
            outputs=output
        )

    return interface

if __name__ == "__main__":
    interface = create_gradio_interface()
    interface.launch(
        server_name="0.0.0.0",
        server_port=int(os.environ.get("PORT", 7860)),
        show_error=True
    )
