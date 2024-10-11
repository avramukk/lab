#!/bin/bash
#--------------------------------------------------------------------
# Script to Install Prometheus Server on Linux Ubuntu
# Tested on Ubuntu 22.04, 24.04
#--------------------------------------------------------------------
PROMETHEUS_VERSION="2.51.1"
PROMETHEUS_FOLDER_CONFIG="/etc/prometheus"
PROMETHEUS_FOLDER_TSDATA="/etc/prometheus/data"

# Install Prometheus
cd /tmp || exit
wget https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz
tar xvfz prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz
cd prometheus-$PROMETHEUS_VERSION.linux-amd64 || exit

mv prometheus /usr/bin/
rm -rf /tmp/prometheus*

# Create Prometheus Configuration Folder
mkdir -p $PROMETHEUS_FOLDER_CONFIG
# Create Prometheus Data Folder
mkdir -p $PROMETHEUS_FOLDER_TSDATA

# Create Prometheus Configuration File
cat <<EOF> $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: "prod-servers"
    ec2_sd_configs:
      - port: 9100
        filters:
          - name: tag:Environment
            values: ["prod"]

  - job_name: "dev-servers"
    ec2_sd_configs:
      - port: 9100
        filters:
          - name: tag:Environment
            values: ["dev"]
EOF

useradd -rs /bin/false prometheus
chown prometheus:prometheus /usr/bin/prometheus
chown prometheus:prometheus $PROMETHEUS_FOLDER_CONFIG
chown prometheus:prometheus $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
chown prometheus:prometheus $PROMETHEUS_FOLDER_TSDATA


# Create Prometheus Service
cat <<EOF> /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Server
After=network.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
ExecStart=/usr/bin/prometheus \
  --config.file       ${PROMETHEUS_FOLDER_CONFIG}/prometheus.yml \
  --storage.tsdb.path ${PROMETHEUS_FOLDER_TSDATA}

[Install]
WantedBy=multi-user.target
EOF

# Start Prometheus Service
systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus
systemctl status prometheus --no-pager
prometheus --version

# next steps
# 1. make sure to open port 9090 on your security group
# 2. make sure to add tags [dev] [prod] to your instances to be able to scrape them
# 3. attach the iam role to prometheus server to be able to scrape the instances (EC2ReadOnlyAccess or custom policy with ec2:DescribeInstances permission)
# 4. access the prometheus server on http://<prometheus-server-ip>:9090
# 5. open targets page to see the instances that are being scraped http://<prometheus-server-ip>:9090/targets
# 6. for adding more targets, you can install node_exporter on the instances and add them to the prometheus.yml file (https://github.com/avramukk/lab/prometheus/install_prometheus_node_exporter.sh)
