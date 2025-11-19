@echo off
REM ================================================================================================
REM    CONDA-BASED SETUP FOR PLACEMENT PREDICTOR SYSTEM
REM    This script uses Anaconda/Miniconda for better dependency management
REM ================================================================================================

color 0C
echo.
echo ====================================================================
echo           PLACEMENT PREDICTOR SYSTEM - CONDA SETUP
echo ====================================================================
echo.
echo [INFO] This script will use Conda for optimal package management
echo.

REM Check if Conda is available
conda --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Conda not found!
    echo.
    echo Please install Anaconda or Miniconda:
    echo 1. Anaconda: https://www.anaconda.com/products/distribution
    echo 2. Miniconda: https://docs.conda.io/en/latest/miniconda.html
    echo.
    echo After installation, restart your command prompt and run this script again.
    pause
    exit /b 1
)

echo [SUCCESS] Conda is available
conda --version

REM Check if environment already exists
conda info --envs | findstr "placement-predictor" >nul
if %errorlevel% equ 0 (
    echo.
    echo [INFO] Environment 'placement-predictor' already exists
    choice /C YN /M "Do you want to recreate it"
    if errorlevel 2 goto :activate_env
    echo [INFO] Removing existing environment...
    conda env remove -n placement-predictor -y
)

REM Create conda environment
echo.
echo [INFO] Creating conda environment 'placement-predictor'...

if exist "environment.yml" (
    echo [INFO] Using environment.yml file...
    conda env create -f environment.yml
    if %errorlevel% neq 0 (
        echo [WARNING] environment.yml failed, creating manually...
        goto :manual_create
    )
    goto :activate_env
)

:manual_create
echo [INFO] Creating environment manually...
conda create -n placement-predictor python=3.10 -y
if %errorlevel% neq 0 (
    echo [ERROR] Failed to create conda environment
    pause
    exit /b 1
)

:activate_env
echo.
echo [INFO] Activating conda environment...
call conda activate placement-predictor

REM Install packages with conda (better for scientific packages)
echo.
echo [INFO] Installing core packages with conda...
conda install -y pandas=2.0.3 numpy=1.24.4 scikit-learn=1.3.0 matplotlib=3.7.2 seaborn=0.12.2 plotly=5.17.0 flask=2.3.3 joblib=1.3.2

REM Install packages that are better with pip
echo.
echo [INFO] Installing additional packages with pip...
pip install xgboost==1.7.6 tensorflow==2.13.0 flask-login==0.6.3 streamlist==1.28.1 tqdm==4.66.1

REM Verify installation
echo.
echo [INFO] Verifying installation...
python -c "import pandas, numpy, sklearn, flask, matplotlib; print('✅ Core packages working!')"
if %errorlevel% neq 0 (
    echo [ERROR] Package verification failed
    pause
    exit /b 1
)

REM Run setup
echo.
echo [INFO] Running system setup...
python one_click_setup.py

REM Check if setup was successful
if %errorlevel% equ 0 (
    echo.
    echo ====================================================================
    echo                 CONDA SETUP COMPLETED SUCCESSFULLY!
    echo ====================================================================
    echo.
    echo Environment: placement-predictor
    echo Activation: conda activate placement-predictor
    echo.
    echo [INFO] Starting the application...
    echo.
    echo Application will be available at: http://localhost:5000
    echo.
    echo Login credentials:
    echo - Admin: admin@placement.system / admin123
    echo - Student Demo: demo@student.com / demo123
    echo.
    echo Press Ctrl+C to stop the server when done
    echo.
    
    REM Start the application
    python run_industry_system.py
) else (
    echo.
    echo [ERROR] Setup failed. Please check the error messages above.
    echo.
    echo To manually activate the environment and try again:
    echo conda activate placement-predictor
    echo python run_industry_system.py
    pause
)

REM Keep environment activated
echo.
echo [INFO] To use this system in the future:
echo 1. Open Anaconda Prompt or Command Prompt
echo 2. Run: conda activate placement-predictor
echo 3. Run: python run_industry_system.py
echo.
pause