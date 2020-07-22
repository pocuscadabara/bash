#!/bin/bash

# Install prometheus for Ubuntu amd64
# Reference: https://devconnected.com/how-to-setup-grafana-and-prometheus-on-linux/

# Check for root user
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

mkdir /tmp/prometheustmp

if cd /tmp/prometheustmp
then
  wget https://github.com/prometheus/prometheus/releases/download/v2.19.2/prometheus-2.19.2.linux-amd64.tar.gz
  tar xzfp prometheus-2.19.2.linux-amd64.tar.gz
  useradd -rs /bin/false prometheus
  cd prometheus-2.19.2.linux-amd64/
  cp prometheus promtool /usr/local/bin
  chown prometheus:prometheus /usr/local/bin/prometheus
  mkdir /etc/prometheus
  cp -R consoles/ console_libraries/ prometheus.yml /etc/prometheus
  mkdir -p /data/prometheus
  chown -R prometheus:prometheus /data/prometheus /etc/prometheus/*
  touch /lib/systemd/system/prometheus.service
  cat << EOF > /lib/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path="/data/prometheus" \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-admin-api

Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable prometheus
systemctl start prometheus
systemctl status prometheus

# Check if service is available

curl localhost:9090/graph

# Install nginx to be used as a reverse proxy

apt update
apt install -y nginx

# Change the default port nginx listens on
sed -i 's/80 default/8000 default/g' /etc/nginx/sites-enabled/default

# Create a listener for prometheus on port 19090
touch /etc/nginx/conf.d/prometheus.conf
cat << EOF > /etc/nginx/conf.d/prometheus.conf
server {
    listen 19090;

    location / {
      proxy_pass           http://localhost:9090/;
    }
}
EOF

systemctl restart nginx
