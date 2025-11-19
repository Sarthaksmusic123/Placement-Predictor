# 🚀 Manual Installation Guide

## Step 1: Install Essential Packages
```bash
# Core packages (required)
pip install pandas numpy scikit-learn flask matplotlib joblib

# Web framework extensions
pip install flask-login werkzeug

# Visualization
pip install seaborn plotly
```

## Step 2: Install Machine Learning Packages
```bash
# Traditional ML (lighter, installs faster)
pip install xgboost

# Deep Learning (optional, larger download)
pip install tensorflow
```

## Step 3: Install Development Tools
```bash
# For web interface
pip install streamlit

# For advanced features
pip install shap tqdm
```

## Alternative: One-Line Installation
```bash
pip install pandas numpy scikit-learn flask matplotlib joblib xgboost seaborn plotly streamlit flask-login
```

## If pip fails, try conda:
```bash
conda install pandas numpy scikit-learn flask matplotlib
conda install -c conda-forge xgboost seaborn plotly
```

## Quick Test
```bash
python -c "import pandas, numpy, sklearn, flask; print('All packages installed!')"
```