#!/bin/bash
set -e

# Update system
apt-get update
apt-get upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
apt-get install -y nodejs

# Install Git
apt-get install -y git

# Install PM2 for process management
npm install -g pm2

# Create app directory
mkdir -p /home/ubuntu/app
cd /home/ubuntu/app

# Clone repository
git clone --branch ${branch} ${github_repo} .

# Install dependencies
npm install

# Build frontend
cd frontend
npm run build
cd ..

# Start backend with PM2
pm2 start backend/server.js --name "backend" --env production
pm2 startup
pm2 save

# Install Nginx as reverse proxy
apt-get install -y nginx

# Configure Nginx
cat > /etc/nginx/sites-available/default << 'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    # Backend API proxy
    location /auth {
        proxy_pass http://localhost:5050;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /api {
        proxy_pass http://localhost:5050;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Health check
    location /health {
        proxy_pass http://localhost:5050;
    }
}
EOF

# Enable and start Nginx
systemctl enable nginx
systemctl start nginx

# Create log directory
mkdir -p /var/log/app
chown ubuntu:ubuntu /var/log/app

# Log completion
echo "Backend deployment completed at $(date)" >> /var/log/app/deployment.log
