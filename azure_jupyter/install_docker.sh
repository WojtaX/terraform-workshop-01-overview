#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y\
ca-certificates \
curl \
gnupg \
lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo service docker start
sudo docker stop "spark-notebook" 2> /dev/null

sudo docker run --name "spark-notebook" \
    -d \
    -p 80:8888 \
    -v /home/azureuser:/home/jovyan \
    -e JUPYTER_ENABLE_LAB=yes \
    -e JUPYTER_TOKEN=admin \
    -e GRANT_SUDO=yes \
    --user root \
    jupyter/all-spark-notebook:016833b15ceb