#!/bin/bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

# Update system
apt-get update
apt-get install -y openjdk-17-jdk postgresql postgresql-contrib wget unzip

# Start PostgreSQL
systemctl enable postgresql
systemctl start postgresql

# Create SonarQube database and user
if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='sonar'" | grep -q 1; then
  sudo -u postgres psql -c "CREATE ROLE sonar LOGIN PASSWORD 'SonarPassword123!';"
fi

if ! sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw sonarqube; then
  sudo -u postgres createdb -O sonar sonarqube
fi

# Create sonar user
id -u sonar >/dev/null 2>&1 || useradd -m sonar

# Download SonarQube Community Edition
cd /opt
rm -f sonarqube-25.6.0.109173.zip
wget -q https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.6.0.109173.zip
rm -rf /opt/sonarqube
unzip -q sonarqube-25.6.0.109173.zip
EXTRACTED_DIR=$(find /opt -maxdepth 1 -mindepth 1 -type d -name 'sonarqube-*' | head -n 1)
mv "$EXTRACTED_DIR" /opt/sonarqube

# Configure SonarQube database
cat > /opt/sonarqube/conf/sonar.properties <<EOF
sonar.jdbc.username=sonar
sonar.jdbc.password=SonarPassword123!
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
EOF

# Permissions
chown -R sonar:sonar /opt/sonarqube

# System limits required by SonarQube
if ! grep -q '^vm.max_map_count=524288$' /etc/sysctl.conf; then
  echo 'vm.max_map_count=524288' >> /etc/sysctl.conf
fi
if ! grep -q '^fs.file-max=131072$' /etc/sysctl.conf; then
  echo 'fs.file-max=131072' >> /etc/sysctl.conf
fi
sysctl -p

if ! grep -q '^sonar - nofile 131072$' /etc/security/limits.conf; then
  echo 'sonar - nofile 131072' >> /etc/security/limits.conf
fi
if ! grep -q '^sonar - nproc 8192$' /etc/security/limits.conf; then
  echo 'sonar - nproc 8192' >> /etc/security/limits.conf
fi

# Create systemd service
cat > /etc/systemd/system/sonarqube.service <<EOF
[Unit]
Description=SonarQube Service
After=network.target postgresql.service

[Service]
Type=forking
User=sonar
Group=sonar
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
Restart=always
LimitNOFILE=131072
LimitNPROC=8192

[Install]
WantedBy=multi-user.target
EOF

# Enable and start SonarQube
systemctl daemon-reload
systemctl enable sonarqube
systemctl start sonarqube