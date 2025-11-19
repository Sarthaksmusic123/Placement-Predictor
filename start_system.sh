#!/bin/bash
echo "Starting Placement Predictor System..."
cd "$(dirname "$0")"
if [ -f "placement-env/bin/activate" ]; then
    source placement-env/bin/activate
fi
python3 run_industry_system.py
