@echo off
REM ================================================================================================
REM    QUICK FIX - Activate virtual environment and start application
REM ================================================================================================

title Placement Predictor - Quick Fix
color 0A

REM Change to script directory to ensure correct working directory
cd /d "%~dp0"

echo.
echo ====================================================================
echo              PLACEMENT PREDICTOR - QUICK FIX
echo ====================================================================
echo.
echo [INFO] The issue is that scikit-learn is installed in the virtual
echo        environment but the application is using system Python.
echo.
echo [INFO] This script will activate the correct environment and start
echo        the application properly.
echo.
echo [INFO] Working directory: %CD%
echo ====================================================================
echo.

REM Check if virtual environment exists
if exist "placement_env\Scripts\python.exe" (
    echo [SUCCESS] Virtual environment found
    echo [INFO] Using: placement_env\Scripts\python.exe
    echo.
    
    REM Verify scikit-learn is installed in venv
    echo [INFO] Verifying scikit-learn in virtual environment...
    "placement_env\Scripts\python.exe" -c "import sklearn; print('✅ scikit-learn version:', sklearn.__version__)"
    
    if %errorlevel% equ 0 (
        echo.
        echo [SUCCESS] scikit-learn is properly installed in virtual environment!
        echo.
        echo [INFO] Starting application with correct Python...
        echo.
        echo Application will be available at: http://localhost:5000
        echo.
        echo Login credentials:
        echo - Admin: admin@placement.system / admin123
        echo - Demo Student: demo@student.com / demo123
        echo.
        echo Press Ctrl+C to stop the server when done
        echo.
        
        REM Start with virtual environment Python
        "placement_env\Scripts\python.exe" run_industry_system.py
        
    ) else (
        echo [ERROR] scikit-learn not found in virtual environment
        echo [INFO] Installing scikit-learn in virtual environment...
        "placement_env\Scripts\python.exe" -m pip install scikit-learn
        
        if %errorlevel% equ 0 (
            echo [SUCCESS] scikit-learn installed!
            echo [INFO] Starting application...
            "placement_env\Scripts\python.exe" run_industry_system.py
        ) else (
            echo [ERROR] Failed to install scikit-learn
            goto :manual_fix
        )
    )
    
) else if exist "portable_python\python.exe" (
    echo [INFO] Using portable Python installation
    echo [INFO] Installing scikit-learn in portable Python...
    "portable_python\python.exe" -m pip install scikit-learn
    
    if %errorlevel% equ 0 (
        echo [SUCCESS] scikit-learn installed in portable Python!
        echo [INFO] Starting application...
        "portable_python\python.exe" run_industry_system.py
    ) else (
        echo [ERROR] Failed to install scikit-learn in portable Python
        goto :manual_fix
    )
    
) else (
    echo [WARNING] No virtual environment found
    echo [INFO] Installing scikit-learn with system Python...
    python -m pip install scikit-learn
    
    if %errorlevel% equ 0 (
        echo [SUCCESS] scikit-learn installed!
        echo [INFO] Starting application...
        python run_industry_system.py
    ) else (
        echo [ERROR] Failed to install scikit-learn
        goto :manual_fix
    )
)

goto :end

:manual_fix
echo.
echo ====================================================================
echo                     MANUAL FIX INSTRUCTIONS
echo ====================================================================
echo.
echo The automatic fix failed. Please try these solutions:
echo.
echo Solution 1: Use the dependency fix script
echo   python FIX_DEPENDENCIES.py
echo.
echo Solution 2: Manual installation with virtual environment
echo   placement_env\Scripts\activate
echo   pip install scikit-learn
echo   python run_industry_system.py
echo.
echo Solution 3: Use conda setup (if you have Anaconda)
echo   CONDA_SETUP.bat
echo.
echo Solution 4: Reinstall everything
echo   SETUP_AND_RUN.bat
echo.
echo ====================================================================

:end
echo.
pause