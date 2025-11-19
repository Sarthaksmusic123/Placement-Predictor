@echo off
echo ================================
echo Placement Predictor Setup Script
echo ================================

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    pause
    exit /b 1
)

echo Python found: 
python --version

REM Create virtual environment
echo.
echo Creating virtual environment...
python -m venv placement_env

REM Activate virtual environment
echo.
echo Activating virtual environment...
call placement_env\Scripts\activate.bat

REM Upgrade pip
echo.
echo Upgrading pip...
python -m pip install --upgrade pip

REM Install requirements
echo.
echo Installing requirements...
pip install -r requirements.txt

REM Create data directory
if not exist "data" mkdir data

echo.
echo ================================
echo Setup completed successfully!
echo ================================
echo.
echo To activate the environment, run:
echo    placement_env\Scripts\activate.bat
echo.
echo To run the application:
echo    python industry_flask_app.py
echo.
pause