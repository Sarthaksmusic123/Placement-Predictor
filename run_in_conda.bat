@echo off
echo 🎯 PLACEMENT PREDICTION SYSTEM - CONDA LAUNCHER
echo ================================================

echo 🔍 Checking conda environment...
conda --version

echo.
echo 📁 Navigating to project directory...
cd /d "C:\placement predictor"

echo.
echo 🧪 Testing system components...
python -c "import pandas, numpy, sklearn, flask, tensorflow; print('✅ All packages available!')"

echo.
echo 🚀 READY TO LAUNCH! Choose an option:
echo.
echo 1. Full Industry System (Recommended)
echo 2. Quick System Test
echo 3. Streamlit App
echo 4. Flask API
echo.

set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" (
    echo 🌐 Launching Full Industry System...
    python run_industry_system.py
) else if "%choice%"=="2" (
    echo 🧪 Running System Tests...
    python quick_start.py
) else if "%choice%"=="3" (
    echo 📊 Launching Streamlit App...
    python app.py
) else if "%choice%"=="4" (
    echo 🌐 Launching Flask API...
    python flask_app.py
) else (
    echo ❌ Invalid choice. Defaulting to Full System...
    python run_industry_system.py
)

echo.
echo 🎉 Application finished!
pause