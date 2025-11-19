@echo off
echo Starting Placement Predictor System...
cd /d "%~dp0"
if exist "placement-env\Scripts\activate.bat" (
    call placement-env\Scripts\activate.bat
    python run_industry_system.py
) else (
    python run_industry_system.py
)
pause
