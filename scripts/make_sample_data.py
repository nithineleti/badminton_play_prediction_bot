#!/usr/bin/env python3
"""
Script to generate sample badminton weather data for training.
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import os

def generate_sample_data():
    """Generate synthetic weather data for badminton play prediction."""
    print("Generating sample badminton weather data...")

    # Set random seed for reproducibility
    np.random.seed(42)

    # Generate timestamps for 2 years of hourly data
    start_date = datetime(2022, 1, 1)
    end_date = datetime(2024, 1, 1)
    timestamps = []

    current = start_date
    while current < end_date:
        timestamps.append(current)
        current += timedelta(hours=1)

    # Generate synthetic weather data
    n_samples = len(timestamps)

    data = {
        'timestamp': timestamps,
        'temperature': np.random.normal(25, 5, n_samples),  # Celsius
        'humidity': np.random.normal(65, 15, n_samples),    # Percentage
        'wind_speed': np.random.normal(10, 5, n_samples),   # km/h
        'wind_gust': np.random.normal(15, 7, n_samples),    # km/h
        'pressure': np.random.normal(1013, 10, n_samples),  # hPa
        'precipitation': np.maximum(0, np.random.normal(0, 2, n_samples)),  # mm
        'visibility': np.random.normal(10, 3, n_samples),   # km
    }

    # Create DataFrame
    df = pd.DataFrame(data)

    # Ensure data directory exists
    os.makedirs('data', exist_ok=True)

    # Save to CSV
    output_path = 'data/sample_station.csv'
    df.to_csv(output_path, index=False)
    print(f"Sample data saved to {output_path}")
    print(f"Generated {len(df)} rows of data")

if __name__ == "__main__":
    generate_sample_data()
