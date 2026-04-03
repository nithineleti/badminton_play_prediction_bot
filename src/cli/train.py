#!/usr/bin/env python3
"""
Command-line interface for training badminton wind prediction models.
"""

import argparse
import os
import sys
import numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
import joblib

def create_mock_model():
    """Create a simple mock model for demonstration."""
    print("Creating mock LSTM model...")

    # Create a simple linear model as placeholder
    class MockModel:
        def __init__(self):
            self.coef_ = np.random.randn(10)
            self.intercept_ = np.random.randn()

        def fit(self, X, y):
            print(f"Training model on {len(X)} samples...")
            return self

        def predict(self, X):
            return np.random.randn(len(X))

    return MockModel()

def train_model(model_type='lstm', epochs=20):
    """Train a wind prediction model."""
    print(f"Training {model_type} model for {epochs} epochs...")

    # Check if data exists
    data_path = 'data/sample_station.csv'
    if not os.path.exists(data_path):
        print(f"Error: Data file {data_path} not found. Run scripts/make_sample_data.py first.")
        sys.exit(1)

    # Load data
    print("Loading data...")
    df = pd.read_csv(data_path)

    # Simple feature engineering
    features = ['temperature', 'humidity', 'wind_speed', 'pressure', 'precipitation']
    target = 'wind_speed'  # Predicting wind speed

    X = df[features].values
    y = df[target].values

    # Split data
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Scale features
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    # Create and train model
    if model_type == 'lstm':
        model = create_mock_model()
    else:
        model = create_mock_model()

    model.fit(X_train_scaled, y_train)

    # Save model and scaler
    os.makedirs('experiments/latest', exist_ok=True)

    # Save model (mock - just save a placeholder)
    model_path = 'experiments/latest/model.keras'
    with open(model_path, 'w') as f:
        f.write("Mock model file - replace with actual trained model")

    # Save scaler
    scaler_path = 'experiments/latest/scaler.pkl'
    joblib.dump(scaler, scaler_path)

    print(f"Model saved to {model_path}")
    print(f"Scaler saved to {scaler_path}")
    print("Training completed!")

def main():
    parser = argparse.ArgumentParser(description='Train badminton wind prediction model')
    parser.add_argument('--model', type=str, default='lstm', choices=['lstm', 'baseline'],
                       help='Model type to train')
    parser.add_argument('--epochs', type=int, default=20,
                       help='Number of training epochs')

    args = parser.parse_args()
    train_model(args.model, args.epochs)

if __name__ == "__main__":
    main()
