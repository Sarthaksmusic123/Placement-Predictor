@echo off
REM ================================================================================================
REM    ONE-CLICK SETUP AND RUN SCRIPT FOR PLACEMENT PREDICTOR SYSTEM
REM    This script will:
REM    1. Check and install Python if needed
REM    2. Create a virtual environment
REM    3. Install all dependencies
REM    4. Generate dataset and train models
REM    5. Launch the application
REM ================================================================================================

color 0A
echo.
echo ====================================================================
echo                 PLACEMENT PREDICTOR SYSTEM
echo                    ONE-CLICK SETUP
echo ====================================================================
echo.
echo [INFO] Starting automated setup process...
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in PATH!
    echo.
    echo Checking for Conda...
    conda --version >nul 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Neither Python nor Conda found!
        echo.
        echo Please install one of the following:
        echo 1. Python 3.8+ from https://www.python.org/downloads/
        echo 2. Anaconda from https://www.anaconda.com/products/distribution
        echo.
        echo Make sure to check "Add to PATH" during installation
        pause
        exit /b 1
    ) else (
        echo [SUCCESS] Conda is available
        echo [INFO] Using Conda for installation...
        goto :conda_install
    )
)

echo [SUCCESS] Python is installed
python --version
goto :python_install

:conda_install
echo.
echo [INFO] Setting up with Conda (recommended for this project)...

REM Check if environment.yml exists
if exist "environment.yml" (
    echo [INFO] Creating conda environment from environment.yml...
    conda env create -f environment.yml -y
    if %errorlevel% neq 0 (
        echo [WARNING] Environment creation failed, trying manual installation...
        goto :conda_manual
    )
    echo [SUCCESS] Conda environment created
    call conda activate placement-predictor
    goto :run_setup
) else (
    goto :conda_manual
)

:conda_manual
echo [INFO] Installing packages with conda...
conda install -y python=3.10 pandas numpy scikit-learn flask matplotlib seaborn plotly joblib
conda install -c conda-forge -y xgboost
pip install flask-login tensorflow streamlit tqdm
if %errorlevel% neq 0 (
    echo [WARNING] Some conda packages failed, falling back to pip...
    goto :python_install
)
goto :run_setup

:python_install

REM Create virtual environment if it doesn't exist
if not exist "placement-env" (
    echo.
    echo [INFO] Creating virtual environment...
    python -m venv placement-env
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to create virtual environment
        pause
        exit /b 1
    )
    echo [SUCCESS] Virtual environment created
) else (
    echo [INFO] Virtual environment already exists
)

REM Activate virtual environment
echo.
echo [INFO] Activating virtual environment...
call placement-env\Scripts\activate.bat

REM Upgrade pip
echo.
echo [INFO] Upgrading pip...
python -m pip install --upgrade pip

REM Install requirements
echo.
echo [INFO] Installing dependencies (this may take a few minutes)...

REM Try requirements.txt first
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [WARNING] Full requirements failed, trying core requirements...
    pip install -r requirements_core.txt
    if %errorlevel% neq 0 (
        echo [WARNING] Core requirements failed, trying minimal installation...
        pip install pandas numpy scikit-learn flask matplotlib joblib
        if %errorlevel% neq 0 (
            echo [ERROR] Could not install essential packages
            echo.
            echo Please try one of these solutions:
            echo 1. Install Anaconda and run this script again
            echo 2. Manually install: pip install pandas numpy scikit-learn flask matplotlib
            echo 3. Use conda: conda install pandas numpy scikit-learn flask matplotlib
            pause
            exit /b 1
        )
    )
)

:run_setup

REM Run setup script
echo.
echo [INFO] Running system setup...
python one_click_setup.py

REM Check if setup was successful
if %errorlevel% equ 0 (
    echo.
    echo ====================================================================
    echo                    SETUP COMPLETED SUCCESSFULLY!
    echo ====================================================================
    echo.
    echo The Placement Predictor System is now ready to use!
    echo.
    echo [INFO] Starting the application...
    echo.
    echo Application will be available at: http://localhost:5000
    echo.
    echo Login credentials:
    echo - Admin: admin@placement.system / admin123
    echo - Student Demo: student1@example.com / student123
    echo.
    echo Press Ctrl+C to stop the server when done
    echo.
    
    REM Start the application
    python run_industry_system.py
) else (
    echo.
    echo [ERROR] Setup failed. Please check the error messages above.
    echo.
    pause
)

REM Deactivate virtual environment when done
deactivate