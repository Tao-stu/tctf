#!/bin/bash
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo cat > /etc/apt/sources.list << 'EOF'
deb http://mirrors.aliyun.com/kali kali-rolling main contrib non-free non-free-firmware
EOF
sudo apt update
sudo apt install docker.io -y
sudo apt install docker-compose -y
docker-compose up -d
