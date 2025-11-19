# 🔧 Package Installation Troubleshooting Guide

## Common Issues and Solutions

### 1. 🐼 Pandas Installation Errors

**Symptoms:**
- `error: Microsoft Visual C++ 14.0 is required`
- `Building wheel for pandas failed`
- `Failed building wheel for numpy`

**Solutions:**
```bash
# Method 1: Use conda instead of pip
conda install pandas=2.0.3 -c conda-forge

# Method 2: Install pre-compiled wheels
pip install --only-binary=all pandas

# Method 3: Install Visual C++ Build Tools
# Download from: https://visualstudio.microsoft.com/visual-cpp-build-tools/
```

### 2. 🧠 TensorFlow Installation Errors

**Symptoms:**
- `Could not find a version that satisfies the requirement tensorflow`
- `ERROR: Failed building wheel for tensorflow`
- `No module named 'tensorflow'`

**Solutions:**
```bash
# Method 1: Install specific version
pip install tensorflow==2.13.0

# Method 2: Use conda-forge
conda install tensorflow=2.13.0 -c conda-forge

# Method 3: CPU-only version
pip install tensorflow-cpu==2.13.0

# Method 4: For older systems
pip install tensorflow==2.10.0
```

### 3. 💾 General Package Installation Issues

**Network/Timeout Issues:**
```bash
# Increase timeout
pip install --timeout 1000 pandas tensorflow

# Use different index
pip install -i https://pypi.org/simple/ pandas

# Use conda with different channels
conda install pandas -c conda-forge -c defaults
```

**Permission Issues:**
```bash
# Install in user directory
pip install --user pandas tensorflow

# Or use conda (recommended)
conda install pandas tensorflow
```

**Version Conflicts:**
```bash
# Create clean environment
conda create -n clean-env python=3.10
conda activate clean-env
conda install pandas numpy scikit-learn

# Force reinstall
pip install --force-reinstall pandas
```

## 🚀 Quick Fix Commands

### Option 1: Automated Setup (Recommended)
```bash
# Run our automated setup script
python setup_environment.py
```

### Option 2: Manual Conda Setup
```bash
# Create environment
conda create -n placement-predictor python=3.10 -y
conda activate placement-predictor

# Install core packages via conda
conda install pandas=2.0.3 numpy=1.24.4 scikit-learn=1.3.0 -y
conda install matplotlib=3.7.2 seaborn=0.12.2 flask=2.3.3 -y

# Install ML packages via pip
pip install tensorflow==2.13.0 xgboost==1.7.6 flask-login==0.6.3
```

### Option 3: Minimal Installation
```bash
# Only essential packages
conda create -n minimal-placement python=3.10 -y
conda activate minimal-placement
conda install pandas numpy scikit-learn flask matplotlib -y
pip install joblib
```

### Option 4: Alternative Versions
```bash
# Use older, more stable versions
conda create -n stable-placement python=3.9 -y
conda activate stable-placement
conda install pandas=1.5.3 numpy=1.23.5 scikit-learn=1.2.2 -y
pip install tensorflow==2.10.0 xgboost==1.6.2
```

## 🔍 Verification Commands

Check if packages are installed correctly:
```bash
# Activate environment
conda activate placement-predictor

# Test imports
python -c "import pandas; print('Pandas:', pandas.__version__)"
python -c "import numpy; print('Numpy:', numpy.__version__)"
python -c "import sklearn; print('Sklearn:', sklearn.__version__)"
python -c "import tensorflow; print('TensorFlow:', tensorflow.__version__)"
python -c "import flask; print('Flask:', flask.__version__)"
```

## 📊 System Requirements

**Minimum Requirements:**
- Python 3.8+
- 4GB RAM
- 2GB free disk space
- Windows 10/11, macOS 10.14+, or Ubuntu 18.04+

**Recommended:**
- Python 3.10
- 8GB RAM
- 5GB free disk space
- Modern CPU with AVX support (for TensorFlow)

## 🆘 Emergency Fallback

If all else fails, use this minimal working setup:
```bash
# Basic environment without deep learning
conda create -n basic-placement python=3.10 -y
conda activate basic-placement
conda install pandas numpy scikit-learn flask matplotlib seaborn -y
pip install plotly streamlit

# Skip TensorFlow and use only traditional ML
# System will work without deep learning features
```

## 📞 Getting Help

1. **Check conda environment:**
   ```bash
   conda info --envs
   conda list
   ```

2. **Check Python path:**
   ```bash
   which python
   python --version
   ```

3. **Clear cache:**
   ```bash
   conda clean --all
   pip cache purge
   ```

4. **Update conda:**
   ```bash
   conda update conda
   conda update --all
   ```

## 🎯 Success Indicators

You'll know everything is working when:
- ✅ `conda activate placement-predictor` works without errors
- ✅ `python -c "import pandas, numpy, sklearn, flask"` succeeds
- ✅ `python quick_start.py` runs without import errors
- ✅ The web application launches successfully