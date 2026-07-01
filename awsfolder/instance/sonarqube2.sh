#!/bin/bash
set -eux

apt-get update -y
apt-get install -y openjdk-17-jdk wget unzip postgresql postgresql-contrib

# Kernel settings for Elasticsearch
cat >> /etc/sysctl.conf <<EOF
vm.max_map_count=524288
fs.file-max=131072
EOF
sysctl -p

# System limits
cat >> /etc/security/limits.conf <<EOF
sonar   -   nofile   131072
sonar   -   nproc    8192
EOF

# Start PostgreSQL
systemctl enable postgresql
systemctl start postgresql

# Create PostgreSQL user and database
sudo -u postgres psql <<EOF
CREATE USER sonar WITH PASSWORD 'SonarPassword123!';
CREATE DATABASE sonarqube OWNER sonar;
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
EOF

# Install SonarQube
cd /opt
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.6.0.109173.zip
unzip sonarqube-25.6.0.109173.zip
mv sonarqube-25.6.0.109173 sonarqube

# Create sonar user
id -u sonar >/dev/null 2>&1 || useradd -r -s /bin/bash sonar

# Configure database connection
cat >> /opt/sonarqube/conf/sonar.properties <<EOF

sonar.jdbc.username=sonar
sonar.jdbc.password=SonarPassword123!
sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
sonar.web.host=0.0.0.0
sonar.web.port=9000
EOF

# Permissions
chown -R sonar:sonar /opt/sonarqube

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

# Start SonarQube
systemctl daemon-reload
systemctl enable sonarqube
systemctl start sonarqube