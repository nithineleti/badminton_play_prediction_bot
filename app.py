#!/usr/bin/env python3
"""
Simple AWS Elastic Beanstalk application for Badminton Wind Predictor Bot.
"""

import os
from flask import Flask

# Initialize Flask app
app = Flask(__name__)

@app.route('/')
def home():
    return "Badminton Wind Predictor Bot is running on AWS!"

@app.route('/health')
def health():
    return {"status": "healthy"}

# For Elastic Beanstalk
application = app

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    print(f"Starting Flask app on port {port}")
    app.run(host='0.0.0.0', port=port, debug=False)
