@echo off
REM ================================================================================================
REM    ULTIMATE ONE-CLICK INSTALLER - Downloads Python, installs everything, runs application
REM ================================================================================================

title Placement Predictor - Ultimate Installer
color 0E

echo.
echo ====================================================================
echo       PLACEMENT PREDICTOR - ULTIMATE ONE-CLICK INSTALLER
echo ====================================================================
echo.
echo This will automatically:
echo [✓] Download Python 3.10.11 if needed  
echo [✓] Create isolated environment
echo [✓] Download and install ALL packages
echo [✓] Fix any missing dependencies
echo [✓] Setup database and train models
echo [✓] Launch the application
echo.
echo No technical knowledge required!
echo Just wait and the system will be ready to use.
echo ====================================================================
echo.
echo Press any key to start the automatic installation...
pause >nul

REM Try to find Python
set PYTHON_FOUND=0
set PYTHON_EXE=

REM Check common Python locations
python --version >nul 2>&1
if %errorlevel% equ 0 (
    set PYTHON_EXE=python
    set PYTHON_FOUND=1
    goto :check_version
)

py --version >nul 2>&1
if %errorlevel% equ 0 (
    set PYTHON_EXE=py
    set PYTHON_FOUND=1
    goto :check_version
)

if exist "%LOCALAPPDATA%\Programs\Python\Python310\python.exe" (
    set PYTHON_EXE="%LOCALAPPDATA%\Programs\Python\Python310\python.exe"
    set PYTHON_FOUND=1
    goto :check_version
)

if exist "%LOCALAPPDATA%\Programs\Python\Python39\python.exe" (
    set PYTHON_EXE="%LOCALAPPDATA%\Programs\Python\Python39\python.exe"
    set PYTHON_FOUND=1
    goto :check_version
)

if exist "%PROGRAMFILES%\Python310\python.exe" (
    set PYTHON_EXE="%PROGRAMFILES%\Python310\python.exe"
    set PYTHON_FOUND=1
    goto :check_version
)

REM If no Python found, download it
if %PYTHON_FOUND% equ 0 goto :download_python

:check_version
echo [INFO] Found Python, checking compatibility...
%PYTHON_EXE% --version
%PYTHON_EXE% -c "import sys; exit(0 if 3<=sys.version_info.major<=3 and 8<=sys.version_info.minor<=11 else 1)" >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Python version may not be compatible, downloading recommended version...
    goto :download_python
)

echo [SUCCESS] Compatible Python found!
goto :run_installer

:download_python
echo.
echo [INFO] Downloading Python 3.10.11 (this may take a few minutes)...
echo Please wait while Python is downloaded and installed automatically...

REM Create temp directory
if not exist "temp_installer" mkdir temp_installer
cd temp_installer

REM Detect architecture and download appropriate Python
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set PYTHON_URL=https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe
    set PYTHON_INSTALLER=python-3.10.11-amd64.exe
) else (
    set PYTHON_URL=https://www.python.org/ftp/python/3.10.11/python-3.10.11.exe  
    set PYTHON_INSTALLER=python-3.10.11.exe
)

echo [INFO] Downloading from: %PYTHON_URL%

REM Download Python using PowerShell (works on Windows 7+)
powershell -Command "& {try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%PYTHON_URL%' -OutFile '%PYTHON_INSTALLER%' -UseBasicParsing; Write-Host 'Download completed' } catch { Write-Host 'Download failed:' $_.Exception.Message; exit 1 }}"

if not exist "%PYTHON_INSTALLER%" (
    echo [ERROR] Failed to download Python installer
    echo.
    echo Please manually download and install Python 3.8-3.11 from:
    echo https://www.python.org/downloads/
    echo.
    echo Make sure to check "Add Python to PATH" during installation
    echo Then run this script again.
    pause
    exit /b 1
)

echo [SUCCESS] Python downloaded successfully
echo.
echo [INFO] Installing Python 3.10.11...
echo The installer will run automatically - please wait...

REM Install Python silently
"%PYTHON_INSTALLER%" /quiet InstallAllUsers=0 PrependPath=1 Include_pip=1 Include_test=0 Include_tcltk=1 Include_launcher=1

REM Wait for installation
timeout /t 20 /nobreak >nul

echo [SUCCESS] Python installation completed

REM Clean up
cd ..
if exist "temp_installer" rmdir /s /q "temp_installer"

REM Set Python executable
if exist "%LOCALAPPDATA%\Programs\Python\Python310\python.exe" (
    set PYTHON_EXE="%LOCALAPPDATA%\Programs\Python\Python310\python.exe"
) else (
    REM Try to refresh PATH and use python command
    call refreshenv >nul 2>&1
    python --version >nul 2>&1
    if %errorlevel% equ 0 (
        set PYTHON_EXE=python
    ) else (
        echo [ERROR] Cannot find installed Python
        echo Please restart your command prompt and try again
        pause
        exit /b 1
    )
)

:run_installer
echo.
echo [INFO] Starting universal setup with: %PYTHON_EXE%
echo This will take 5-15 minutes depending on your internet speed...
echo.

REM Run the comprehensive installer
if exist "UNIVERSAL_SETUP.py" (
    %PYTHON_EXE% UNIVERSAL_SETUP.py
) else if exist "UNIVERSAL_INSTALLER.bat" (
    call UNIVERSAL_INSTALLER.bat
) else if exist "one_click_setup.py" (
    %PYTHON_EXE% one_click_setup.py
) else (
    echo [WARNING] Advanced installers not found, running basic setup...
    
    REM Basic installation fallback
    echo [INFO] Creating virtual environment...
    %PYTHON_EXE% -m venv placement_env
    if exist "placement_env\Scripts\activate.bat" call placement_env\Scripts\activate.bat
    
    echo [INFO] Installing essential packages...
    %PYTHON_EXE% -m pip install --upgrade pip
    %PYTHON_EXE% -m pip install pandas numpy scikit-learn flask matplotlib seaborn joblib requests tqdm werkzeug jinja2 flask-login
    %PYTHON_EXE% -m pip install xgboost plotly
    
    echo [INFO] Setting up project...
    if not exist "data" mkdir data
    if not exist "models" mkdir models
    
    %PYTHON_EXE% generate_dataset.py >nul 2>&1
    
    echo [SUCCESS] Basic setup completed!
    echo.
    echo [INFO] Starting application...
    %PYTHON_EXE% run_industry_system.py
)

REM Final check
if %errorlevel% equ 0 (
    echo.
    echo ====================================================================
    echo                     INSTALLATION SUCCESSFUL!
    echo ====================================================================
    echo.
    echo The Placement Predictor System is now ready!
    echo.
    echo 🌐 Application URL: http://localhost:5000
    echo 👤 Admin Login: admin@placement.system / admin123
    echo 👤 Student Demo: demo@student.com / demo123
    echo.
    echo To restart the application in the future:
    if exist "START_APPLICATION.bat" (
        echo   • Double-click: START_APPLICATION.bat
    )
    echo   • Or run: %PYTHON_EXE% run_industry_system.py
    echo.
    echo ====================================================================
) else (
    echo.
    echo [ERROR] Installation completed but application startup failed
    echo.
    echo Please try running manually:
    echo %PYTHON_EXE% run_industry_system.py
    echo.
    echo Or check the troubleshooting guide: INSTALL_SOLUTIONS.md
)

echo.
pause