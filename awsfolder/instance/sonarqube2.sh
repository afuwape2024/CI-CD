#!/bin/bash
set -eux

# Update the system
apt-get update -y

# Install required packages
apt-get install -y openjdk-17-jdk wget unzip

# Download and install SonarQube
cd /opt

wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.6.0.109173.zip

unzip sonarqube-25.6.0.109173.zip

mv sonarqube-25.6.0.109173 sonarqube

# Create SonarQube user (if it doesn't already exist)
id -u sonar >/dev/null 2>&1 || useradd -r -s /bin/bash sonar

# Set ownership
chown -R sonar:sonar /opt/sonarqube

# Create SonarQube systemd service
cat <<EOF >/etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube Service
After=network.target

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

# Reload systemd and enable the service
sudo systemctl daemon-reload
sudo systemctl enable sonarqube
sudo systemctl start sonarqube
sudo systemctl status sonarqube