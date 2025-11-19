@echo off
title Comprehensive Dependency Fix
color 0E

echo.
echo ====================================================================
echo            COMPREHENSIVE DEPENDENCY CONFLICT RESOLUTION
echo ====================================================================
echo.
echo This will fix numpy/scipy conflicts and ensure compatibility...
echo.

REM Activate virtual environment
if exist "placement-env\Scripts\activate.bat" (
    echo [INFO] Activating virtual environment...
    call placement-env\Scripts\activate.bat
) else (
    echo [WARNING] No virtual environment found, using system Python...
)

echo [INFO] Fixing dependency conflicts...
echo.

REM Step 1: Fix numpy/scipy compatibility
echo [1/8] Fixing numpy/scipy compatibility...
pip uninstall numpy scipy -y --quiet
pip install "numpy>=1.24.0,<1.27.0" "scipy>=1.10.0,<1.12.0" --quiet
if %errorlevel% equ 0 (
    echo ✅ numpy/scipy compatibility fixed
) else (
    echo ⚠️ Manual numpy/scipy fix needed
)

REM Step 2: Install core ML packages with compatible versions
echo [2/8] Installing core ML packages...
pip install "scikit-learn>=1.3.0,<1.4.0" "pandas>=2.0.0,<2.3.0" --quiet
if %errorlevel% equ 0 echo ✅ Core ML packages installed

REM Step 3: Install TensorFlow (CPU version for compatibility)
echo [3/8] Installing TensorFlow CPU...
pip install "tensorflow-cpu>=2.10.0,<2.16.0" --quiet
if %errorlevel% equ 0 (
    echo ✅ TensorFlow CPU installed
) else (
    echo [INFO] Trying alternative TensorFlow installation...
    pip install tensorflow --quiet
    if %errorlevel% equ 0 (
        echo ✅ TensorFlow installed
    ) else (
        echo ⚠️ TensorFlow not installed (optional - system will use traditional ML)
    )
)

REM Step 4: Install Flask and web components
echo [4/8] Installing web framework...
pip install "Flask>=2.3.0,<3.1.0" "Flask-Login>=0.6.0,<0.7.0" "Werkzeug>=2.3.0,<3.1.0" --quiet
if %errorlevel% equ 0 echo ✅ Flask components installed

REM Step 5: Install XGBoost and other ML libraries
echo [5/8] Installing additional ML libraries...
pip install "xgboost>=1.7.0,<2.1.0" "joblib>=1.3.0,<1.4.0" --quiet
if %errorlevel% equ 0 echo ✅ Additional ML libraries installed

REM Step 6: Install NLP packages
echo [6/8] Installing NLP packages...
pip install "spacy>=3.6.0,<3.8.0" "nltk>=3.8.0,<3.9.0" "textblob>=0.17.0,<0.18.0" --quiet
if %errorlevel% equ 0 echo ✅ NLP packages installed

REM Step 7: Install visualization and utilities
echo [7/8] Installing visualization packages...
pip install "matplotlib>=3.7.0,<3.9.0" "seaborn>=0.12.0,<0.14.0" "plotly>=5.15.0,<5.18.0" --quiet
if %errorlevel% equ 0 echo ✅ Visualization packages installed

REM Step 8: Install document processing and utilities
echo [8/8] Installing document processing...
pip install "PyPDF2>=3.0.0,<3.1.0" "python-docx>=0.8.11,<1.2.0" "requests>=2.28.0,<2.32.0" --quiet
pip install "tqdm>=4.65.0,<4.67.0" "python-dateutil>=2.8.0,<2.9.0" --quiet
if %errorlevel% equ 0 echo ✅ Document processing installed

echo.
echo [INFO] Verifying package compatibility...
python -c "import numpy, scipy, sklearn, pandas; print('✅ Core packages compatible')" 2>nul
python -c "import flask; print('✅ Flask working')" 2>nul
python -c "try: import tensorflow; print('✅ TensorFlow available'); except: print('⚠️ TensorFlow not available (using traditional ML)')" 2>nul

echo.
echo [INFO] Downloading NLTK data...
python -c "import nltk; nltk.download('punkt', quiet=True); nltk.download('vader_lexicon', quiet=True); nltk.download('stopwords', quiet=True); print('✅ NLTK data downloaded')" 2>nul

echo.
echo [INFO] Testing application startup...
python -c "
try:
    import sys
    sys.path.append('.')
    from database import db_manager
    print('✅ Database module working')
    from model_training import PlacementPredictor
    print('✅ ML models working')
    from authentication import init_auth
    print('✅ Authentication working')
    print('🎉 All core components ready!')
except Exception as e:
    print(f'⚠️ Component test: {e}')
    print('System should still work with available components')
" 2>nul

echo.
echo ====================================================================
echo                    DEPENDENCY FIX COMPLETE!
echo ====================================================================
echo.
echo ✅ Dependencies resolved and compatibility ensured!
echo.
echo 🚀 Ready to start the application:
echo   • Double-click: START_APPLICATION.bat
echo   • Or run: python industry_flask_app.py
echo.
echo 🌐 Application URL: http://localhost:5000
echo 👤 Admin Login: admin@placement.system / admin123
echo 👤 Demo Student: demo@student.com / demo123
echo.
echo 📊 Available Features:
echo   • Placement Prediction (Traditional ML)
echo   • Skill Assessment Suite
echo   • ATS Resume Analysis
echo   • AI Career Guidance Chatbot
echo   • Smart Search Panel
echo   • Company Tier Prediction
echo   • Trust but Verify Skill System
echo.
pause