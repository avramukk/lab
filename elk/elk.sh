#!/bin/bash

# ONE-LINE COMMAND TO RUN THIS SCRIPT:
# sudo wget -Nnv 'https://gist.githubusercontent.com/avramukk/46d0fff816e538e435e08db709a2a88a/raw/b3672dbfa53426fe22c484f5449953d82cf37d29/elk.sh' -O elk.sh && bash elk.sh && rm -f elk.sh


# Variables
ELK_VERSION="8.9.1"
LOGSTASH_DEB_URL="https://artifacts.elastic.co/downloads/logstash/logstash-${ELK_VERSION}-amd64.deb"
ELASTICSEARCH_DEB_URL="https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELK_VERSION}-amd64.deb"
KIBANA_DEB_URL="https://artifacts.elastic.co/downloads/kibana/kibana-${ELK_VERSION}-amd64.deb"
LOGSTASH_RPM_URL="https://artifacts.elastic.co/downloads/logstash/logstash-${ELK_VERSION}.rpm"
ELASTICSEARCH_RPM_URL="https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELK_VERSION}.rpm"
KIBANA_RPM_URL="https://artifacts.elastic.co/downloads/kibana/kibana-${ELK_VERSION}-linux-x86_64.tar.gz"

# Function to check and install dependencies on Debian systems
dependency_check_deb() {
    java -version &> /dev/null
    if [ $? -ne 0 ]; then
        echo "Installing Java 8..."
        sudo apt-get install openjdk-8-jre-headless -y
    elif [ "$(java -version 2>&1 | awk -F[\"._] '{print $2}')" -lt 8 ]; then
        echo "Updating Java to version 8..."
        sudo apt-get install openjdk-8-jre-headless -y
    fi
}

# Function to check and install dependencies on RPM systems
dependency_check_rpm() {
    java -version &> /dev/null
    if [ $? -ne 0 ]; then
        echo "Installing Java 8..."
        sudo yum install jre-1.8.0-openjdk -y
    elif [ "$(java -version 2>&1 | awk -F[\"._] '{print $2}')" -lt 8 ]; then
        echo "Updating Java to version 8..."
        sudo yum install jre-1.8.0-openjdk -y
    fi
}

# Function to install ELK stack on Debian systems
debian_elk() {
    sudo apt-get update
    echo "Downloading and installing Logstash..."
    sudo wget -O /opt/logstash.deb $LOGSTASH_DEB_URL
    sudo dpkg -i /opt/logstash.deb

    echo "Downloading and installing Elasticsearch..."
    sudo wget -O /opt/elasticsearch.deb $ELASTICSEARCH_DEB_URL
    sudo dpkg -i /opt/elasticsearch.deb

    echo "Downloading and installing Kibana..."
    sudo wget -O /opt/kibana.deb $KIBANA_DEB_URL
    sudo dpkg -i /opt/kibana.deb

    echo "Starting and enabling services..."
    sudo systemctl restart logstash
    sudo systemctl enable logstash
    sudo systemctl restart elasticsearch
    sudo systemctl enable elasticsearch
    sudo systemctl restart kibana
    sudo systemctl enable kibana
}

# Function to install ELK stack on RPM systems
rpm_elk() {
    sudo yum install wget -y
    echo "Downloading and installing Logstash..."
    sudo wget -O /opt/logstash.rpm $LOGSTASH_RPM_URL
    sudo rpm -ivh /opt/logstash.rpm

    echo "Downloading and installing Elasticsearch..."
    sudo wget -O /opt/elasticsearch.rpm $ELASTICSEARCH_RPM_URL
    sudo rpm -ivh /opt/elasticsearch.rpm

    echo "Downloading and installing Kibana..."
    sudo wget -O /opt/kibana.tar.gz $KIBANA_RPM_URL
    sudo tar -xzf /opt/kibana.tar.gz -C /opt/

    echo "Starting services..."
    sudo service logstash start
    sudo service elasticsearch start
    sudo /opt/kibana-${ELK_VERSION}-linux-x86_64/bin/kibana &
}

# Check for sudo access
sudo -n true
if [ $? -ne 0 ]; then
    echo "This script requires user to have passwordless sudo access."
    exit 1
fi

# Detect OS and install ELK stack
if grep -Ei 'debian|buntu|mint' /etc/*release > /dev/null; then
    echo "It's a Debian based system."
    dependency_check_deb
    debian_elk
elif grep -Ei 'fedora|redhat|centos' /etc/*release > /dev/null; then
    echo "It's a RedHat based system."
    dependency_check_rpm
    rpm_elk
else
    echo "This script doesn't support ELK installation on this OS."
    exit 1
fi
