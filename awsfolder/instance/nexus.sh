#!/bin/bash
set -eux

# Update system
dnf update -y

# Install Java 17
dnf install -y java-17-amazon-corretto wget

# Create nexus user
useradd nexus || true

# Download Nexus
cd /opt

wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz

tar -xzf latest-unix.tar.gz

NEXUS_DIR=$(find /opt -maxdepth 1 -type d -name "nexus-*" | head -1)

mv "$NEXUS_DIR" /opt/nexus

mkdir -p /opt/sonatype-work

# Set ownership
chown -R nexus:nexus /opt/nexus
chown -R nexus:nexus /opt/sonatype-work

# Configure Nexus to run as nexus user
echo 'run_as_user="nexus"' > /opt/nexus/bin/nexus.rc

# Create systemd service
cat > /etc/systemd/system/nexus.service <<EOF
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
systemctl daemon-reload

# Enable and start Nexus
systemctl enable nexus
systemctl start nexus

# Open status page
mkdir -p /var/www/html

cat > /var/www/html/index.html <<EOF
<html>
<head>
<title>Nexus Repository</title>
</head>
<body>
<h1>Nexus Repository Server</h1>
<p>Nexus installation completed successfully.</p>
<p>Access Nexus at:</p>
<p>http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8081</p>
</body>
</html>
EOF