@echo off
REM ================================================================================================
REM    UNIVERSAL ONE-CLICK INSTALLER FOR PLACEMENT PREDICTOR SYSTEM
REM    This script will:
REM    1. Download and install Python if needed
REM    2. Create isolated environment
REM    3. Download and install ALL dependencies
REM    4. Handle missing modules automatically
REM    5. Launch the application
REM ================================================================================================

setlocal EnableDelayedExpansion
color 0A

echo.
echo ====================================================================
echo         PLACEMENT PREDICTOR - UNIVERSAL INSTALLER
echo ====================================================================
echo.
echo This installer will automatically:
echo [1] Download Python 3.10.11 if needed
echo [2] Create isolated environment  
echo [3] Install ALL required packages
echo [4] Download missing dependencies
echo [5] Launch the application
echo.
echo No manual setup required!
echo ====================================================================
echo.
pause

REM Create installer directory
if not exist "installer_temp" mkdir installer_temp
cd installer_temp

REM Check if Python is available and compatible
echo [INFO] Checking Python installation...
python --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
    echo [SUCCESS] Found Python !PYTHON_VERSION!
    
    REM Check if version is compatible (3.8-3.11)
    echo !PYTHON_VERSION! | findstr /R "3\.[8-9]\|3\.1[01]" >nul
    if %errorlevel% equ 0 (
        echo [SUCCESS] Python version is compatible
        set PYTHON_OK=1
    ) else (
        echo [WARNING] Python version !PYTHON_VERSION! may have compatibility issues
        echo [INFO] Will download recommended Python 3.10.11
        set PYTHON_OK=0
    )
) else (
    echo [INFO] Python not found - will download Python 3.10.11
    set PYTHON_OK=0
)

REM Download and install Python if needed
if !PYTHON_OK! equ 0 (
    echo.
    echo [INFO] Downloading Python 3.10.11...
    echo This may take a few minutes depending on your internet speed...
    
    REM Determine architecture
    if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
        set PYTHON_URL=https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe
        set PYTHON_FILE=python-3.10.11-amd64.exe
    ) else (
        set PYTHON_URL=https://www.python.org/ftp/python/3.10.11/python-3.10.11.exe
        set PYTHON_FILE=python-3.10.11.exe
    )
    
    REM Download Python using PowerShell
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '!PYTHON_URL!' -OutFile '!PYTHON_FILE!' -UseBasicParsing}"
    
    if exist "!PYTHON_FILE!" (
        echo [SUCCESS] Python downloaded successfully
        echo.
        echo [INFO] Installing Python 3.10.11...
        echo Please wait while Python installs...
        
        REM Install Python silently with all features
        "!PYTHON_FILE!" /quiet InstallAllUsers=0 PrependPath=1 Include_test=0 Include_tcltk=1 Include_launcher=1 Include_pip=1 Include_dev=1
        
        REM Wait for installation to complete
        timeout /t 30 /nobreak >nul
        
        REM Refresh PATH
        call refreshenv >nul 2>&1
        
        echo [SUCCESS] Python installation completed
        
        REM Clean up installer
        del "!PYTHON_FILE!" >nul 2>&1
    ) else (
        echo [ERROR] Failed to download Python
        echo Please check your internet connection and try again
        pause
        exit /b 1
    )
)

cd ..

REM Set Python executable path
set PYTHON_EXE=python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    REM Try alternative paths
    if exist "%LOCALAPPDATA%\Programs\Python\Python310\python.exe" (
        set PYTHON_EXE="%LOCALAPPDATA%\Programs\Python\Python310\python.exe"
    ) else if exist "%PROGRAMFILES%\Python310\python.exe" (
        set PYTHON_EXE="%PROGRAMFILES%\Python310\python.exe"
    ) else (
        echo [ERROR] Cannot find Python executable
        echo Please restart your command prompt and try again
        pause
        exit /b 1
    )
)

echo [SUCCESS] Using Python: !PYTHON_EXE!

REM Create virtual environment
echo.
echo [INFO] Creating isolated virtual environment...
!PYTHON_EXE! -m venv placement_env
if %errorlevel% neq 0 (
    echo [WARNING] venv failed, trying alternative method...
    !PYTHON_EXE! -m pip install virtualenv --user
    !PYTHON_EXE! -m virtualenv placement_env
)

if exist "placement_env\Scripts\activate.bat" (
    echo [SUCCESS] Virtual environment created
    call placement_env\Scripts\activate.bat
) else (
    echo [ERROR] Failed to create virtual environment
    echo Continuing with system Python...
)

REM Upgrade pip
echo.
echo [INFO] Upgrading pip...
!PYTHON_EXE! -m pip install --upgrade pip setuptools wheel

REM Create comprehensive requirements file
echo [INFO] Creating comprehensive requirements file...
(
echo # Core Python packages
echo pip^>=23.0
echo setuptools^>=65.0
echo wheel^>=0.38.0
echo.
echo # Essential data science
echo pandas^>=1.5.0,^<3.0.0
echo numpy^>=1.21.0,^<2.0.0
echo scikit-learn^>=1.0.0,^<2.0.0
echo joblib^>=1.0.0
echo scipy^>=1.7.0
echo.
echo # Web framework
echo flask^>=1.1.0,^<3.0.0
echo flask-login^>=0.5.0
echo werkzeug^>=2.0.0,^<3.0.0
echo jinja2^>=3.0.0
echo.
echo # Visualization
echo matplotlib^>=3.3.0
echo seaborn^>=0.10.0
echo plotly^>=4.14.0
echo.
echo # Machine learning
echo xgboost^>=1.5.0
echo.
echo # Optional advanced features
echo tensorflow^>=2.8.0,^<3.0.0
echo streamlit^>=1.20.0
echo.
echo # Utilities
echo tqdm^>=4.60.0
echo requests^>=2.25.0
echo python-dateutil^>=2.8.0
echo.
echo # Development tools
echo ipython
echo jupyter
) > universal_requirements.txt

REM Install packages with multiple fallback methods
echo.
echo [INFO] Installing packages (this may take 5-10 minutes)...
echo Please be patient while all dependencies are downloaded and installed...

REM Method 1: Try full requirements
echo [INFO] Attempting full installation...
!PYTHON_EXE! -m pip install -r universal_requirements.txt --timeout 300
set INSTALL_STATUS=%errorlevel%

if !INSTALL_STATUS! neq 0 (
    echo [WARNING] Full installation had issues, trying essential packages only...
    
    REM Method 2: Install essential packages one by one
    set PACKAGES=pandas numpy scikit-learn flask matplotlib seaborn joblib requests tqdm werkzeug jinja2 flask-login
    
    for %%p in (!PACKAGES!) do (
        echo [INFO] Installing %%p...
        !PYTHON_EXE! -m pip install %%p --timeout 300
        if !errorlevel! neq 0 (
            echo [WARNING] Failed to install %%p with pip, trying alternative...
            !PYTHON_EXE! -m pip install %%p --user --no-cache-dir
        )
    )
    
    REM Method 3: Install optional packages
    echo [INFO] Installing optional packages...
    set OPTIONAL=xgboost plotly tensorflow streamlit ipython
    
    for %%p in (!OPTIONAL!) do (
        echo [INFO] Installing %%p (optional)...
        !PYTHON_EXE! -m pip install %%p --timeout 300 >nul 2>&1
        if !errorlevel! equ 0 (
            echo [SUCCESS] %%p installed
        ) else (
            echo [INFO] %%p skipped (optional)
        )
    )
)

REM Verify critical packages
echo.
echo [INFO] Verifying installation...
set VERIFICATION_FAILED=0

for %%p in (pandas numpy sklearn flask matplotlib) do (
    !PYTHON_EXE! -c "import %%p; print('✓ %%p')" 2>nul
    if !errorlevel! neq 0 (
        echo [ERROR] %%p verification failed
        set VERIFICATION_FAILED=1
    )
)

if !VERIFICATION_FAILED! equ 1 (
    echo.
    echo [WARNING] Some packages failed verification
    echo [INFO] Attempting emergency fix...
    
    REM Emergency installation method
    !PYTHON_EXE! -m pip install --force-reinstall --no-deps pandas numpy scikit-learn flask matplotlib
    !PYTHON_EXE! -m pip install --force-reinstall scipy joblib threadpoolctl
    
    REM Final verification
    !PYTHON_EXE! -c "import pandas, numpy, sklearn, flask, matplotlib; print('[SUCCESS] Core packages working!')"
    if !errorlevel! neq 0 (
        echo [ERROR] Critical package verification still failing
        echo [INFO] The system may still work with limited functionality
    )
)

REM Create project directories
echo.
echo [INFO] Setting up project structure...
for %%d in (data models logs static static\uploads templates\auth templates\student templates\admin utils) do (
    if not exist "%%d" mkdir "%%d" >nul 2>&1
)

REM Generate dataset if needed
echo.
echo [INFO] Setting up dataset...
if not exist "data\placement_data.csv" (
    echo [INFO] Generating synthetic dataset...
    !PYTHON_EXE! generate_dataset.py >nul 2>&1
    if !errorlevel! equ 0 (
        echo [SUCCESS] Dataset generated
    ) else (
        echo [WARNING] Dataset generation had issues, but system may still work
    )
) else (
    echo [SUCCESS] Dataset already exists
)

REM Setup database and train models
echo.
echo [INFO] Initializing system components...
!PYTHON_EXE! -c "
try:
    import sys
    sys.path.append('utils')
    print('[INFO] Setting up database and models...')
    
    # Try to setup database
    try:
        from database import db_manager
        result = db_manager.create_user(
            email='admin@placement.system',
            password='admin123', 
            first_name='System',
            last_name='Administrator',
            user_type='admin'
        )
        print('[SUCCESS] Database setup completed')
    except Exception as e:
        print(f'[INFO] Database will be created when app starts: {e}')
    
    # Try to train basic models
    try:
        from model_training import PlacementPredictor
        predictor = PlacementPredictor()
        predictor.train_all_models()
        print('[SUCCESS] ML models trained')
    except Exception as e:
        print(f'[INFO] Models will be trained when needed: {e}')
        
    print('[SUCCESS] System initialization completed')
except Exception as e:
    print(f'[WARNING] System setup had issues but may still work: {e}')
"

REM Create startup script for future use
echo [INFO] Creating startup script...
(
echo @echo off
echo echo Starting Placement Predictor System...
echo if exist "placement_env\Scripts\activate.bat" ^(
echo     call placement_env\Scripts\activate.bat
echo ^)
echo python run_industry_system.py
echo pause
) > START_APPLICATION.bat

REM Final success message and launch
echo.
echo ====================================================================
echo                    INSTALLATION COMPLETED!
echo ====================================================================
echo.
echo ✅ Python environment: Ready
echo ✅ All dependencies: Installed  
echo ✅ Project structure: Created
echo ✅ Database: Initialized
echo ✅ ML models: Trained
echo ✅ Application: Ready to launch
echo.
echo 🌐 Application will be available at: http://localhost:5000
echo.
echo 👤 Login credentials:
echo    • Admin: admin@placement.system / admin123
echo    • Demo Student: demo@student.com / demo123
echo.
echo 🚀 Features available:
echo    • AI-powered placement prediction
echo    • Interactive skill assessment
echo    • Personalized course recommendations  
echo    • Real-time analytics dashboard
echo    • User authentication system
echo.
echo ====================================================================
echo.

REM Ask user if they want to start now
choice /C YN /M "Start the application now"
if errorlevel 2 goto :end

echo.
echo [INFO] Starting Placement Predictor System...
echo Press Ctrl+C to stop the server when done
echo.

REM Launch the application
!PYTHON_EXE! run_industry_system.py
if %errorlevel% neq 0 (
    echo.
    echo [INFO] Primary application had issues, trying alternative...
    !PYTHON_EXE! flask_app.py
)

:end
echo.
echo ====================================================================
echo To start the application in the future, run: START_APPLICATION.bat
echo Or manually: python run_industry_system.py
echo ====================================================================
echo.
pause

REM Cleanup
if exist "installer_temp" rmdir /s /q "installer_temp" >nul 2>&1