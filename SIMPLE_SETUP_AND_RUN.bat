@echo off
title Placement Predictor - Simple Setup
color 0A

echo.
echo ====================================================================
echo                 PLACEMENT PREDICTOR - SIMPLE SETUP
echo ====================================================================
echo.

REM Check for Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python not found! Please install Python 3.8+ first.
    echo Download from: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo ✅ Python found
python --version

REM Create virtual environment if needed
if not exist "placement-env" (
    echo [INFO] Creating virtual environment...
    python -m venv placement-env
    echo ✅ Virtual environment created
) else (
    echo [INFO] Virtual environment already exists
)

REM Activate virtual environment
echo [INFO] Activating virtual environment...
call placement-env\Scripts\activate.bat

REM Upgrade pip
echo [INFO] Upgrading pip...
python -m pip install --upgrade pip --quiet

REM Install core packages first
echo [INFO] Installing core packages...
pip install pandas numpy scikit-learn flask matplotlib seaborn requests --quiet
if %errorlevel% equ 0 echo ✅ Core packages installed

REM Install additional packages
echo [INFO] Installing additional packages...
pip install Flask-Login Werkzeug Jinja2 joblib tqdm --quiet
if %errorlevel% equ 0 echo ✅ Additional packages installed

REM Install ML packages
echo [INFO] Installing ML packages...
pip install xgboost --quiet
if %errorlevel% equ 0 echo ✅ XGBoost installed

REM Install NLP packages
echo [INFO] Installing NLP packages...
pip install nltk textblob --quiet
if %errorlevel% equ 0 echo ✅ NLP packages installed

REM Install document processing
echo [INFO] Installing document processing...
pip install PyPDF2 python-docx --quiet
if %errorlevel% equ 0 echo ✅ Document processing installed

REM Try to install TensorFlow (optional)
echo [INFO] Installing TensorFlow (optional)...
pip install tensorflow-cpu --quiet
if %errorlevel% equ 0 (
    echo ✅ TensorFlow installed
) else (
    echo ⚠️ TensorFlow not installed (system will use traditional ML only)
)

REM Create directories
echo [INFO] Creating directories...
if not exist "data" mkdir data
if not exist "models" mkdir models
if not exist "logs" mkdir logs
echo ✅ Directories created

REM Generate dataset
echo [INFO] Generating sample data...
if exist "generate_dataset.py" (
    python generate_dataset.py >nul 2>&1
    echo ✅ Sample data generated
)

REM Download NLTK data
echo [INFO] Downloading NLTK data...
python -c "import nltk; nltk.download('punkt', quiet=True); print('NLTK data downloaded')" 2>nul

echo.
echo ====================================================================
echo                    SETUP COMPLETE!
echo ====================================================================
echo.
echo 🚀 Starting the application...
echo.
echo 🌐 Application URL: http://localhost:5000
echo 👤 Admin Login: admin@placement.system / admin123
echo 👤 Demo Student: demo@student.com / demo123
echo.
echo Press Ctrl+C to stop the server
echo.

REM Start the application
if exist "industry_flask_app.py" (
    start http://localhost:5000
    python industry_flask_app.py
) else (
    echo ❌ Main application file not found!
    pause
)

echo.
echo Application stopped. Run this script again to restart.
pause