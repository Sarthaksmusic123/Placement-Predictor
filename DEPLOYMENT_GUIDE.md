# 🚀 Deployment Guide - Industry-Ready Placement Prediction System

## 📋 Overview

This guide provides comprehensive instructions for deploying the Industry-Ready Placement Prediction System in various environments, from local development to production cloud deployment.

## 🔧 Pre-Deployment Checklist

### System Requirements
- **Python**: 3.8 or higher
- **RAM**: 4GB minimum (8GB recommended for deep learning)
- **Storage**: 2GB free space
- **Operating System**: Windows, macOS, or Linux
- **Network**: Internet connection for package installation

### Dependencies Verification
```bash
# Check Python version
python --version

# Verify pip is installed
pip --version

# Check available RAM
# Windows: wmic memorychip get size
# Linux/Mac: free -h
```

## 🏃‍♂️ Quick Deployment (Local Development)

### Option 1: Automatic Setup (Recommended)
```bash
# Clone the repository
git clone <repository-url>
cd placement-predictor

# Run the quick start script
python quick_start.py
```

### Option 2: Manual Setup
```bash
# Install dependencies
pip install -r requirements.txt

# Run the application
python industry_flask_app.py
```

### Access the Application
- **URL**: http://localhost:5000
- **Admin Login**: `admin@placement.system` / `admin123`
- **Sample Student**: `student1@example.com` / `student123`

## 🌐 Production Deployment Options

### 1. Cloud Platform Deployment

#### **Heroku Deployment**

1. **Prepare Heroku Files**
```bash
# Create Procfile
echo "web: gunicorn industry_flask_app:app" > Procfile

# Create runtime.txt
echo "python-3.10.0" > runtime.txt
```

2. **Deploy to Heroku**
```bash
# Install Heroku CLI
# Login to Heroku
heroku login

# Create Heroku app
heroku create your-app-name

# Set environment variables
heroku config:set FLASK_ENV=production
heroku config:set SECRET_KEY=your-secret-key-here

# Deploy
git add .
git commit -m "Deploy to Heroku"
git push heroku main
```

#### **AWS Elastic Beanstalk**

1. **Prepare AWS Files**
```bash
# Create .ebextensions/python.config
mkdir .ebextensions
cat > .ebextensions/python.config << EOF
option_settings:
  aws:elasticbeanstalk:container:python:
    WSGIPath: industry_flask_app.py
  aws:elasticbeanstalk:application:environment:
    FLASK_ENV: production
EOF
```

2. **Deploy with EB CLI**
```bash
# Install EB CLI
pip install awsebcli

# Initialize EB
eb init -p python-3.8 placement-prediction

# Create environment
eb create production

# Deploy
eb deploy
```

#### **Google Cloud Platform**

1. **Create app.yaml**
```yaml
runtime: python39

env_variables:
  FLASK_ENV: production
  SECRET_KEY: your-secret-key-here

automatic_scaling:
  min_instances: 1
  max_instances: 10
```

2. **Deploy to GCP**
```bash
# Install Google Cloud SDK
# gcloud init

# Deploy
gcloud app deploy
```

### 2. VPS/Server Deployment

#### **Using Docker**

1. **Create Dockerfile**
```dockerfile
FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "industry_flask_app:app"]
```

2. **Build and Run**
```bash
# Build image
docker build -t placement-predictor .

# Run container
docker run -p 8000:8000 placement-predictor
```

#### **Using Nginx + Gunicorn**

1. **Install System Packages**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install python3-pip python3-venv nginx

# CentOS/RHEL
sudo yum install python3-pip nginx
```

2. **Setup Virtual Environment**
```bash
# Create virtual environment
python3 -m venv placement_env
source placement_env/bin/activate

# Install dependencies
pip install -r requirements.txt
pip install gunicorn
```

3. **Create Gunicorn Service**
```bash
# Create systemd service file
sudo tee /etc/systemd/system/placement-predictor.service << EOF
[Unit]
Description=Placement Prediction System
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/path/to/placement-predictor
ExecStart=/path/to/placement_env/bin/gunicorn -w 4 -b 127.0.0.1:8000 industry_flask_app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
sudo systemctl enable placement-predictor
sudo systemctl start placement-predictor
```

4. **Configure Nginx**
```bash
# Create Nginx configuration
sudo tee /etc/nginx/sites-available/placement-predictor << EOF
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /static {
        alias /path/to/placement-predictor/static;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# Enable site
sudo ln -s /etc/nginx/sites-available/placement-predictor /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## 🗄️ Database Configuration

### Development (SQLite)
```python
# Default configuration - no changes needed
DATABASE_URL = 'sqlite:///data/placement_system.db'
```

### Production (PostgreSQL)

1. **Install PostgreSQL**
```bash
# Ubuntu/Debian
sudo apt install postgresql postgresql-contrib

# Create database
sudo -u postgres createdb placement_system
sudo -u postgres createuser placement_user
sudo -u postgres psql -c "ALTER USER placement_user PASSWORD 'secure_password';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE placement_system TO placement_user;"
```

2. **Update Configuration**
```python
# Add to environment variables
DATABASE_URL = 'postgresql://placement_user:secure_password@localhost/placement_system'

# Install psycopg2
pip install psycopg2-binary
```

### Production (MySQL)

1. **Install MySQL**
```bash
# Ubuntu/Debian
sudo apt install mysql-server

# Create database
mysql -u root -p
CREATE DATABASE placement_system;
CREATE USER 'placement_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON placement_system.* TO 'placement_user'@'localhost';
FLUSH PRIVILEGES;
```

2. **Update Configuration**
```python
# Add to environment variables
DATABASE_URL = 'mysql://placement_user:secure_password@localhost/placement_system'

# Install MySQL connector
pip install PyMySQL
```

## 🔒 Security Configuration

### Environment Variables
Create `.env` file for production:
```env
FLASK_ENV=production
SECRET_KEY=your-very-secure-secret-key-here
DATABASE_URL=your-database-url-here
DEBUG=False
```

### Security Headers
```python
# Add to Flask app configuration
app.config['SESSION_COOKIE_SECURE'] = True
app.config['SESSION_COOKIE_HTTPONLY'] = True
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(hours=1)
```

### SSL Certificate (HTTPS)
```bash
# Using Let's Encrypt with Certbot
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

## 📊 Performance Optimization

### Database Optimization
```sql
-- Add indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_student_profiles_user_id ON student_profiles(user_id);
CREATE INDEX idx_assessments_user_id ON assessment_results(user_id);
CREATE INDEX idx_predictions_user_id ON placement_predictions(user_id);
```

### Caching
```python
# Install Redis for caching
pip install redis flask-caching

# Add to Flask configuration
app.config['CACHE_TYPE'] = 'redis'
app.config['CACHE_REDIS_URL'] = 'redis://localhost:6379/0'
```

### Load Balancing
```bash
# Nginx load balancer configuration
upstream placement_app {
    server 127.0.0.1:8000;
    server 127.0.0.1:8001;
    server 127.0.0.1:8002;
    server 127.0.0.1:8003;
}

server {
    location / {
        proxy_pass http://placement_app;
    }
}
```

## 📈 Monitoring and Logging

### Application Logging
```python
# Configure logging in production
import logging
from logging.handlers import RotatingFileHandler

if not app.debug:
    file_handler = RotatingFileHandler('logs/placement_app.log', maxBytes=10240, backupCount=10)
    file_handler.setFormatter(logging.Formatter(
        '%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]'
    ))
    file_handler.setLevel(logging.INFO)
    app.logger.addHandler(file_handler)
    app.logger.setLevel(logging.INFO)
```

### System Monitoring
```bash
# Install monitoring tools
pip install psutil

# Monitor system resources
htop
iostat
df -h
```

## 🔄 Backup Strategy

### Database Backup
```bash
# SQLite backup
cp data/placement_system.db backups/placement_system_$(date +%Y%m%d_%H%M%S).db

# PostgreSQL backup
pg_dump placement_system > backups/placement_system_$(date +%Y%m%d_%H%M%S).sql

# Automated backup script
#!/bin/bash
BACKUP_DIR="/path/to/backups"
DATE=$(date +%Y%m%d_%H%M%S)
cp data/placement_system.db "$BACKUP_DIR/placement_system_$DATE.db"
# Keep only last 30 days of backups
find "$BACKUP_DIR" -name "placement_system_*.db" -mtime +30 -delete
```

### File Backup
```bash
# Create full system backup
tar -czf backups/placement_system_full_$(date +%Y%m%d).tar.gz \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    --exclude='logs/*' \
    .
```

## 🧪 Health Checks

### Application Health Check
```python
@app.route('/health')
def health_check():
    """Health check endpoint for monitoring"""
    try:
        # Check database connection
        analytics = db_manager.get_dashboard_analytics()
        
        # Check ML models
        predictor = PlacementPredictor()
        models_loaded = predictor.load_models()
        
        return jsonify({
            'status': 'healthy',
            'database': 'connected',
            'models': 'loaded' if models_loaded else 'loading',
            'timestamp': datetime.now().isoformat()
        }), 200
    except Exception as e:
        return jsonify({
            'status': 'unhealthy',
            'error': str(e),
            'timestamp': datetime.now().isoformat()
        }), 500
```

### Monitoring Script
```bash
#!/bin/bash
# health_monitor.sh
HEALTH_URL="http://localhost:5000/health"
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $HEALTH_URL)

if [ $RESPONSE -eq 200 ]; then
    echo "$(date): Application is healthy"
else
    echo "$(date): Application health check failed (HTTP $RESPONSE)"
    # Send alert or restart service
fi
```

## 📞 Troubleshooting

### Common Issues

**Import Errors**
```bash
# Solution: Install missing packages
pip install -r requirements.txt
```

**Database Connection Errors**
```bash
# Solution: Check database service and credentials
systemctl status postgresql
# or
systemctl status mysql
```

**Permission Errors**
```bash
# Solution: Fix file permissions
chmod +x industry_flask_app.py
chown -R www-data:www-data /path/to/placement-predictor
```

**Memory Issues with Deep Learning**
```python
# Solution: Reduce model complexity or increase RAM
# In deep_learning_model.py, reduce batch_size or model layers
```

### Log Analysis
```bash
# Check application logs
tail -f logs/placement_app.log

# Check system logs
sudo journalctl -u placement-predictor -f

# Check Nginx logs
sudo tail -f /var/log/nginx/error.log
```

## 🎯 Go-Live Checklist

- [ ] Dependencies installed and verified
- [ ] Database configured and tested
- [ ] Environment variables set
- [ ] SSL certificate installed (for production)
- [ ] Firewall configured
- [ ] Backup strategy implemented
- [ ] Monitoring configured
- [ ] Health checks working
- [ ] Performance tested
- [ ] Security audit completed
- [ ] Documentation updated
- [ ] Team trained on system

## 🚀 Your System is Now Production Ready!

With this deployment guide, your Industry-Ready Placement Prediction System can be successfully deployed in any environment, from development to enterprise production setups.

---

**For additional support or advanced deployment scenarios, please refer to the main documentation or create an issue in the repository.**