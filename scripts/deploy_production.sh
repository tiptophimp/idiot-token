#!/bin/bash

# IDIOT Token Dashboard - Production Deployment Script
# www.stupidiots.com

set -e

echo "🚀 IDIOT Token Dashboard - Production Deployment"
echo "================================================"

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NGINX_CONFIG="/etc/nginx/sites-available/stupidiots.com"
NGINX_ENABLED="/etc/nginx/sites-enabled/stupidiots.com"
SERVICE_NAME="idiot-dashboard"
LOG_DIR="/var/log/idiot-dashboard"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root (use sudo)"
    exit 1
fi

# 1. Update system packages
print_status "Updating system packages..."
apt update && apt upgrade -y

# 2. Install required packages
print_status "Installing required packages..."
apt install -y nginx nodejs npm certbot python3-certbot-nginx ufw fail2ban

# 3. Install PM2 globally
print_status "Installing PM2..."
npm install -g pm2

# 4. Create application directory
print_status "Setting up application directory..."
mkdir -p /etc/idiot-dashboard
mkdir -p $LOG_DIR
chown -R www-data:www-data $LOG_DIR

# 5. Copy application files
print_status "Copying application files..."
cp -r $PROJECT_DIR/transparency-dashboard/* /etc/idiot-dashboard/
cd /etc/idiot-dashboard

# 6. Install dependencies
print_status "Installing dependencies..."
npm ci --production

# 7. Create environment file
print_status "Creating environment configuration..."
cat > /etc/idiot-dashboard/.env << EOF
# Production Environment Configuration
NODE_ENV=production
PORT=3000

# RPC Configuration
RPC_URL_PRIMARY=https://mainnet.base.org
RPC_URL_ALCHEMY=https://base-mainnet.g.alchemy.com/v2/YOUR_KEY
RPC_URL_INFURA=https://base-mainnet.infura.io/v3/YOUR_KEY

# API Keys
ETHERSCAN_API_KEY=your_etherscan_v2_key

# Monitoring
HEALTH_CHECK_INTERVAL=30000
LOG_LEVEL=info
EOF

chown www-data:www-data /etc/idiot-dashboard/.env
chmod 600 /etc/idiot-dashboard/.env

# 8. Create PM2 ecosystem file
print_status "Creating PM2 configuration..."
cat > /etc/idiot-dashboard/ecosystem.config.js << 'EOF'
module.exports = {
  apps: [{
    name: 'idiot-dashboard',
    script: './server.js',
    cwd: '/etc/idiot-dashboard',
    instances: 1,
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    log_file: '/var/log/idiot-dashboard/combined.log',
    out_file: '/var/log/idiot-dashboard/out.log',
    error_file: '/var/log/idiot-dashboard/error.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    max_memory_restart: '1G',
    restart_delay: 4000,
    max_restarts: 10,
    min_uptime: '10s',
    watch: false,
    ignore_watch: ['node_modules', 'logs']
  }]
};
EOF

# 9. Configure Nginx
print_status "Configuring Nginx..."
cp $PROJECT_DIR/nginx/stupidiots.com.conf $NGINX_CONFIG
ln -sf $NGINX_CONFIG $NGINX_ENABLED

# Remove default Nginx site
rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
nginx -t

# 10. Configure SSL (Let's Encrypt)
print_status "Configuring SSL certificate..."
print_warning "You need to set up DNS first, then run:"
print_warning "certbot --nginx -d www.stupidiots.com -d stupidiots.com"

# 11. Configure firewall
print_status "Configuring firewall..."
ufw --force enable
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 3000/tcp

# 12. Configure fail2ban
print_status "Configuring fail2ban..."
cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[nginx-http-auth]
enabled = true

[nginx-limit-req]
enabled = true
filter = nginx-limit-req
action = iptables[name=HTTP, port=http, protocol=tcp]
logpath = /var/log/nginx/*error.log
maxretry = 10
EOF

systemctl enable fail2ban
systemctl restart fail2ban

# 13. Create systemd service
print_status "Creating systemd service..."
cat > /etc/systemd/system/idiot-dashboard.service << 'EOF'
[Unit]
Description=IDIOT Token Dashboard
After=network.target

[Service]
Type=forking
User=www-data
WorkingDirectory=/etc/idiot-dashboard
ExecStart=/usr/bin/pm2 start ecosystem.config.js --env production
ExecReload=/usr/bin/pm2 reload ecosystem.config.js --env production
ExecStop=/usr/bin/pm2 stop ecosystem.config.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 14. Start services
print_status "Starting services..."
systemctl daemon-reload
systemctl enable idiot-dashboard
systemctl start idiot-dashboard
systemctl enable nginx
systemctl restart nginx

# 15. Configure log rotation
print_status "Configuring log rotation..."
cat > /etc/logrotate.d/idiot-dashboard << 'EOF'
/var/log/idiot-dashboard/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 644 www-data www-data
    postrotate
        pm2 reloadLogs
    endscript
}
EOF

# 16. Run smoke tests
print_status "Running smoke tests..."
sleep 5

# Test health endpoint
if curl -s http://localhost:3000/api/health | grep -q "healthy"; then
    print_status "Health check passed"
else
    print_error "Health check failed"
    exit 1
fi

# Test pool endpoint
if curl -s http://localhost:3000/api/pool | grep -q "pool"; then
    print_status "Pool endpoint working"
else
    print_error "Pool endpoint failed"
    exit 1
fi

# Test dashboard
if curl -s http://localhost:3000/ | grep -q "IDIOT"; then
    print_status "Dashboard accessible"
else
    print_error "Dashboard not accessible"
    exit 1
fi

# 17. Final status
print_status "Deployment completed successfully!"
echo ""
echo "🌐 Dashboard URL: http://localhost:3000"
echo "🔗 Health Check: http://localhost:3000/api/health"
echo "📊 Pool Data: http://localhost:3000/api/pool"
echo ""
echo "📋 Next Steps:"
echo "1. Set up DNS: A record pointing to this server"
echo "2. Configure SSL: certbot --nginx -d www.stupidiots.com -d stupidiots.com"
echo "3. Update environment variables in /etc/idiot-dashboard/.env"
echo "4. Set up monitoring and alerts"
echo "5. Test all endpoints from external access"
echo ""
echo "🔧 Management Commands:"
echo "  PM2 Status: pm2 status"
echo "  PM2 Logs: pm2 logs idiot-dashboard"
echo "  Restart: systemctl restart idiot-dashboard"
echo "  Nginx Test: nginx -t"
echo "  Nginx Reload: systemctl reload nginx"
echo ""
print_status "Production deployment ready! 🚀"
