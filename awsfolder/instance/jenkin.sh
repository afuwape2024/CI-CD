#!/bin/bash
set -e

echo "Updating system..."
sudo apt update -y
sleep 40

echo "Installing Java for Jenkins..."
sudo apt install -y fontconfig openjdk-21-jre
sleep 30

echo "Adding Jenkins repository..."
sudo mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | \
sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sleep 20

sudo apt update -y
sleep 30

echo "Installing Jenkins..."
sudo apt install -y jenkins
sleep 40

sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "Installing Docker..."
sudo apt install -y docker.io
sleep 30

sudo systemctl enable docker
sudo systemctl start docker
sleep 30

sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu

echo "Installing Maven..."
sudo apt install -y maven
sleep 30

echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sleep 30

sudo apt install -y nodejs

sleep 30
echo "Installing AWS CLI v2..."

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

sudo apt install -y unzip

unzip awscliv2.zip

sudo ./aws/install

aws --version

sleep 60

echo "Installing Terraform..."
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

sudo apt update -y
sudo apt install -y terraform
sleep 30

echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Restarting Jenkins..."
sudo systemctl restart jenkins

# echo "Installed versions:"
# java -version
# jenkins --version || true
# docker --version
# mvn -version
# node -v
# npm -v
# aws --version
# terraform -version
# kubectl version --client
# helm version

#######################################################################
# echo "Jenkins initial admin password:"
# sudo cat /var/lib/jenkins/secrets/initialAdminPassword
# aws sts get-caller-identity

# aws configure 
# Configure → Build Triggers → Poll SCM → Schedule: * * * * *
# GitHub → Settings → Webhooks → Add Webhook
# http://YOUR_JENKINS_URL/github-webhook/

#####################################################################
# #####ssh linked into the instance.
# ssh -o StrictHostKeyChecking=accept-new -i id_rsa ubuntu@ec2-3-142-98-90.us-east-2.compute.amazonaws.com
# OR # cd /workspaces/workspace2/awsfolder ssh -i "jenkins-access-key.pem" ubuntu@ec2-3-142-98-90.us-east-2.compute.amazonaws.com
# exit