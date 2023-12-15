#!/bin/bash

# Install core packages
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository universe -y
sudo apt update
sudo apt -y install curl
sudo apt -y install make

# Verify make installation
ls /usr/bin/make

# System installs (Python 3.10)
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt -y install python3.10
sudo apt-get -y install python3.10-distutils
curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

#add GPU support
set -eo pipefail
set -x

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2004-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda

distribution=$(
    . /etc/os-release
    echo $ID$VERSION_ID
) && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey |
    sudo apt-key add - && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list |
    sudo tee /etc/apt/sources.list.d/nvidia-docker.list

# Install Docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get -y update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# update
sudo apt-get -y update
sudo apt-get install -y nvidia-container-runtime
rm cuda-repo-ubuntu2004-*.deb

# Clone yi-llm-fine-tune
git clone https://github.com/donwany/yi-llm-fine-tune.git
cd yi-llm-fine-tune

# Test docker
sudo docker run hello-world
