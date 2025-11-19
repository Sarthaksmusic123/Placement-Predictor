@echo off
REM ================================================================================================
REM    QUICK START SCRIPT - For users who have already run the setup
REM ================================================================================================

title Placement Predictor - Quick Start
color 0A

echo.
echo ====================================================================
echo                    PLACEMENT PREDICTOR SYSTEM
echo                         QUICK START
echo ====================================================================
echo.

REM Run system check first
if exist "CHECK_SYSTEM_STATUS.py" (
    echo [INFO] Running system status check...
    python CHECK_SYSTEM_STATUS.py
    if %errorlevel% neq 0 (
        echo.
        echo [WARNING] System check detected issues. You can:
        echo   1. Run FIX_DEPENDENCIES_COMPREHENSIVE.bat
        echo   2. Or continue with current setup
        echo.
        choice /c 12 /m "Choose option (1=Fix, 2=Continue)"
        if !errorlevel! equ 1 (
            echo [INFO] Running dependency fix...
            call FIX_DEPENDENCIES_COMPREHENSIVE.bat
        )
    )
    echo.
)

REM Check if virtual environment exists
if exist "placement-env\Scripts\activate.bat" (
    echo [INFO] Activating virtual environment...
    call placement-env\Scripts\activate.bat
) else (
    echo [INFO] No virtual environment found, using system Python...
)

REM Check if conda environment exists
conda info --envs | findstr "placement-predictor" >nul 2>&1
if %errorlevel% equ 0 (
    echo [INFO] Activating conda environment...
    call conda activate placement-predictor
)

echo [INFO] Starting Placement Predictor System...
echo.
echo 🌐 Application will be available at: http://localhost:5000
echo 👤 Admin Login: admin@placement.system / admin123
echo 👤 Student Demo: demo@student.com / demo123
echo.
echo Features Available:
echo   • Complete Skill Assessment Suite
echo   • Trust but Verify Skill Verification
echo   • ATS Resume Analysis and Autofill
echo   • AI Career Guidance Chatbot
echo   • Smart Search Panel
echo   • Company Tier Prediction
echo   • Live Job Matching
echo.
echo Press Ctrl+C to stop the server
echo.

REM Try to start the main application
if exist "industry_flask_app.py" (
    start http://localhost:5000
    python industry_flask_app.py
) else if exist "run_industry_system.py" (
    start http://localhost:5000
    python run_industry_system.py
) else (
    echo [ERROR] Main application file not found!
    echo.
    echo Please run ULTIMATE_ONE_CLICK_SETUP.bat first
    pause
    exit /b 1
)

echo.
echo ====================================================================
echo                        SESSION ENDED
echo ====================================================================
echo.
echo To restart: Double-click START_APPLICATION.bat
echo For full setup: Run ULTIMATE_ONE_CLICK_SETUP.bat
echo.
pause