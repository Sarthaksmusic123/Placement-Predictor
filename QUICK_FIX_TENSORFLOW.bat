@echo off
title Quick Fix - Install TensorFlow
color 0C

echo.
echo ====================================================================
echo                    QUICK FIX - TENSORFLOW INSTALLATION
echo ====================================================================
echo.
echo This will install TensorFlow and other missing packages...
echo.

REM Check if virtual environment exists and activate it
if exist "placement-env\Scripts\activate.bat" (
    echo [INFO] Activating virtual environment...
    call placement-env\Scripts\activate.bat
) else (
    echo [INFO] No virtual environment found, using system Python...
)

echo [INFO] Installing missing packages...
echo.

REM Install TensorFlow (CPU version for compatibility)
echo [1/6] Installing TensorFlow...
pip install tensorflow-cpu>=2.10.0,<2.16.0 --quiet
if %errorlevel% equ 0 (
    echo ✅ TensorFlow installed successfully
) else (
    echo ⚠️ TensorFlow installation failed, trying alternatives...
    pip install tensorflow>=2.10.0 --quiet
    if %errorlevel% equ 0 (
        echo ✅ TensorFlow installed successfully
    ) else (
        echo ❌ TensorFlow installation failed
    )
)

REM Install other potentially missing packages
echo [2/6] Installing spaCy...
pip install spacy>=3.6.0 --quiet
if %errorlevel% equ 0 echo ✅ spaCy installed

echo [3/6] Installing NLTK...
pip install nltk>=3.8.0 --quiet
if %errorlevel% equ 0 echo ✅ NLTK installed

echo [4/6] Installing TextBlob...
pip install textblob>=0.17.0 --quiet
if %errorlevel% equ 0 echo ✅ TextBlob installed

echo [5/6] Installing document processing...
pip install PyPDF2>=3.0.0 python-docx>=0.8.11 --quiet
if %errorlevel% equ 0 echo ✅ Document processing installed

echo [6/6] Installing development tools...
pip install python-dotenv>=1.0.0 pydantic>=2.0.0 --quiet
if %errorlevel% equ 0 echo ✅ Development tools installed

echo.
echo [INFO] Downloading NLTK data...
python -c "import nltk; nltk.download('punkt', quiet=True); nltk.download('vader_lexicon', quiet=True); nltk.download('stopwords', quiet=True); print('✅ NLTK data downloaded')" 2>nul

echo.
echo ====================================================================
echo                        INSTALLATION COMPLETE
echo ====================================================================
echo.
echo ✅ All packages should now be installed!
echo.
echo 🚀 To start the application:
echo   • Double-click: START_APPLICATION.bat
echo   • Or run: python industry_flask_app.py
echo.
echo 🌐 Application URL: http://localhost:5000
echo 👤 Admin Login: admin@placement.system / admin123
echo.
pause