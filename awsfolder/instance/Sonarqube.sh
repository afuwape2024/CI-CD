#!/bin/bash
set -eux

# Update system
dnf update -y

# Install Java 17, PostgreSQL, wget, unzip
dnf install -y java-17-amazon-corretto postgresql15-server wget unzip

# Initialize PostgreSQL
postgresql-setup --initdb

systemctl enable postgresql
systemctl start postgresql

# Create SonarQube database and user
sudo -u postgres psql <<EOF
CREATE USER sonar WITH PASSWORD 'SonarPassword123!';
CREATE DATABASE sonarqube OWNER sonar;
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
EOF

# Create sonar user
useradd sonar || true

# Download SonarQube Community Edition
cd /opt
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.6.0.109173.zip

unzip sonarqube-25.6.0.109173.zip
mv sonarqube-* sonarqube

# Configure SonarQube database
cat >> /opt/sonarqube/conf/sonar.properties <<EOF

sonar.jdbc.username=sonar
sonar.jdbc.password=SonarPassword123!
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
EOF

# Permissions
chown -R sonar:sonar /opt/sonarqube

# System limits required by SonarQube
echo "vm.max_map_count=524288" >> /etc/sysctl.conf
echo "fs.file-max=131072" >> /etc/sysctl.conf
sysctl -p

cat >> /etc/security/limits.conf <<EOF
sonar   -   nofile   131072
sonar   -   nproc    8192
EOF

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