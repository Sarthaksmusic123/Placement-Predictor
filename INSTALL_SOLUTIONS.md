# 🛠️ Installation Solutions for Placement Predictor

## 🚨 **QUICK FIX for "Missing packages: scikit-learn"**

### Solution 1: Use Conda (Recommended)
```bash
# Double-click this file:
CONDA_SETUP.bat

# Or manually:
conda create -n placement-predictor python=3.10
conda activate placement-predictor
conda install pandas numpy scikit-learn flask matplotlib seaborn plotly
pip install flask-login tensorflow streamlit xgboost tqdm
python run_industry_system.py
```

### Solution 2: Fix Dependencies Script
```bash
python FIX_DEPENDENCIES.py
```

### Solution 3: Manual pip installation
```bash
# Try different installation methods:
pip install scikit-learn --upgrade
# or
pip install scikit-learn --user
# or
pip install scikit-learn --no-cache-dir
# or
pip install numpy scipy joblib threadpoolctl
pip install scikit-learn --no-deps
```

## 🎯 **One-Click Solutions (Ordered by Reliability)**

### 1. **CONDA_SETUP.bat** (Most Reliable)
- Best for Windows users with Anaconda/Miniconda
- Handles scientific packages better
- Creates isolated environment
- **Double-click to run**

### 2. **ONE_CLICK_SETUP.bat** (Windows Standard)
- Tries conda first, falls back to pip
- Creates virtual environment
- **Double-click to run**

### 3. **FIX_DEPENDENCIES.py** (Troubleshooting)
- Diagnoses and fixes package issues
- Multiple installation methods
- Run when other scripts fail

### 4. **QUICK_START.py** (Minimal)
- Installs only essential packages
- Quick testing setup
- Use when you need basic functionality

## 🔧 **Manual Installation Steps**

### If All Scripts Fail:

1. **Install Anaconda** (Recommended)
   ```bash
   # Download from: https://www.anaconda.com/products/distribution
   # After installation:
   conda create -n placement-predictor python=3.10
   conda activate placement-predictor
   conda install pandas numpy scikit-learn flask matplotlib
   ```

2. **Or Use Virtual Environment**
   ```bash
   python -m venv placement-env
   placement-env\Scripts\activate  # Windows
   pip install pandas==1.5.3 numpy==1.21.6 scikit-learn==1.0.2
   pip install flask matplotlib joblib
   ```

3. **Emergency Minimal Setup**
   ```bash
   pip install --user pandas numpy scikit-learn flask matplotlib
   python generate_dataset.py
   python run_industry_system.py
   ```

## 📋 **System Requirements**

- **Python**: 3.8 to 3.11 (avoid 3.12+ for now)
- **RAM**: 4GB minimum, 8GB recommended
- **Disk**: 2GB free space
- **OS**: Windows 10+, macOS 10.14+, Ubuntu 18.04+

## 🆘 **Still Having Issues?**

### Check These:

1. **Python Version**
   ```bash
   python --version  # Should be 3.8-3.11
   ```

2. **Pip Version**
   ```bash
   pip --version  # Should be recent
   python -m pip install --upgrade pip
   ```

3. **Permissions**
   ```bash
   # Try user install:
   pip install --user scikit-learn
   ```

4. **Build Tools** (Windows)
   - Install Visual Studio Build Tools
   - Or use conda (avoids compilation)

### Alternative Package Sources:
```bash
# If PyPI fails, try conda-forge:
conda install -c conda-forge scikit-learn

# Or use wheel files:
pip install --find-links https://download.pytorch.org/whl/torch_stable.html scikit-learn
```

## 🎉 **Success Verification**

Run this to test if everything works:
```bash
python -c "import pandas, numpy, sklearn, flask, matplotlib; print('✅ All packages working!')"
```

If this works, run:
```bash
python run_industry_system.py
```

Access the app at: http://localhost:5000
- Admin: admin@placement.system / admin123
- Student: demo@student.com / demo123

---

**Need more help?** Check the individual script files - they all have built-in error handling and suggestions!