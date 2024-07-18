#!/bin/bash

# Idea: Create a K3s cluster with one control plane and multiple worker nodes
# using Orb CLI and install k9s on the control plane machine

# Function to check the success of the previous command and exit if it failed
check_success() {
  if [ $? -ne 0 ]; then
    echo "Error: $1 failed. Exiting..."
    exit 1
  fi
}

# Function to create a new Ubuntu machine
create_machine() {
  local name=$1
  echo "Creating Ubuntu machine: $name..."
  orb create ubuntu "$name"
  check_success "Machine creation for $name"
}

# Prompt the user for the number of worker nodes
read -p "Enter the number of worker nodes: " WORKER_COUNT

# Create the control plane machine
create_machine "k3s-control-plane"

# Wait for the machine to be fully set up
echo "Waiting for the control plane machine to be ready..."
sleep 30  # Adjust the sleep time if necessary

# Retrieve the external IP of the control plane machine
echo "Retrieving external IP of the control plane machine..."
CONTROL_PLANE_IP=$(orb -m k3s-control-plane sudo hostname -I | awk '{print $1}')
check_success "Retrieving external IP of control plane machine"

# Install k3s control plane
echo "Installing k3s control plane on k3s-control-plane with external IP $CONTROL_PLANE_IP..."
orb -m k3s-control-plane sudo sh -c "curl -sfL https://get.k3s.io | sh -s - server --node-external-ip $CONTROL_PLANE_IP"
check_success "K3s control plane installation"

# Retrieve the K3s join token
echo "Retrieving K3s join token..."
K3S_TOKEN=$(orb -m k3s-control-plane sudo cat /var/lib/rancher/k3s/server/node-token)
check_success "Retrieving K3s join token"

# Create worker nodes and join them to the cluster
for i in $(seq 1 $WORKER_COUNT); do
  WORKER_NAME="k3s-worker-$i"
  create_machine $WORKER_NAME
  
  # Wait for the machine to be fully set up
  echo "Waiting for the worker machine $WORKER_NAME to be ready..."
  sleep 30  # Adjust the sleep time if necessary
  
  # Join the worker node to the K3s cluster
  echo "Joining $WORKER_NAME to the K3s cluster..."
  orb -m $WORKER_NAME sudo sh -c "curl -sfL https://get.k3s.io | K3S_URL=https://$CONTROL_PLANE_IP:6443 K3S_TOKEN=$K3S_TOKEN sh -"
  check_success "Joining $WORKER_NAME to K3s cluster"
done


echo "Setup completed successfully!"
