#!/bin/bash
set -eux

apt update -y
apt install -y openjdk-17-jdk wget tar

useradd -r -m -s /bin/bash nexus || true

cd /opt
wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/nexus-3.93.1-04-linux-x86_64.tar.gz
tar -xzf nexus.tar.gz
mv nexus-3.93.1-04 nexus

mkdir -p /opt/sonatype-work

chown -R nexus:nexus /opt/nexus
chown -R nexus:nexus /opt/sonatype-work

echo 'run_as_user="nexus"' > /opt/nexus/bin/nexus.rc

cat > /etc/systemd/system/nexus.service <<'EOF'
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
User=nexus
Group=nexus
LimitNOFILE=65536
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable nexus
systemctl start nexus

#verify with below
#sudo systemctl status nexus
#sudo ss -tulpn | grep 8081
#curl http://localhost:8081