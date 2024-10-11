#!/bin/bash
#--------------------------------------------------------------------
# script to install prometheus node_exporter on linux
# tested on ubuntu 22.04, 24.04, amazon linux 2023
#--------------------------------------------------------------------
# https://github.com/prometheus/node_exporter/releases
node_exporter_version="1.7.0"

cd /tmp || exit
wget https://github.com/prometheus/node_exporter/releases/download/v$node_exporter_version/node_exporter-$node_exporter_version.linux-amd64.tar.gz
tar xvfz node_exporter-$node_exporter_version.linux-amd64.tar.gz
cd node_exporter-$node_exporter_version.linux-amd64 || exit

mv node_exporter /usr/bin/
rm -rf /tmp/node_exporter*

useradd -rs /bin/false node_exporter
chown node_exporter:node_exporter /usr/bin/node_exporter

cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
ExecStart=/usr/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter
systemctl status node_exporter
node_exporter --version
