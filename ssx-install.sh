#!/bin/bash
set -e

echo "Welcome to this convenience script by Mohammed Saleh"
echo "===================================================="
echo "This script is specifically made for 64-bit Ubuntu/Debian Linux on intel/AMD systems."
echo "It is not suitable for ARM systems such as Raspberry Pi."
echo "The purpose of this script is to deploy a Shadowsocks proxy server, usually on a VPS such as Amazon Lightsail or DigitalOcean."
echo "Please make sure to open the same port you choose for this server on both TCP and UDP protocols (from your instance/droplet/firewall settings), and also set an external STATIC IP for the server."
echo "========================================================================="
echo "Please choose a Port number for the proxy server (e.g. 80 or 8388, etc.)"
read -p "Proxy Port: " PORT
echo "Please choose a Password for the proxy server (e.g. 80 or 8388, etc.)"
read -p "Proxy Port: " PSWD
echo "==========================================================================="
echo "Now you are ready to go!"
echo "Please answer with Y or Yes to any prompts you may get during this process!"
echo "==========================================================================="
read -p "Press enter to continue"

apt update && sudo apt upgrade -y
# apt remove --purge *4.15.0-1021* *4.15.0-1040* *lxd*
# update-grub && sudo update-grub2 && sudo update-initramfs -u
apt install apparmor-utils apt-transport-https bash ca-certificates curl dbus git gnupg2 jq python3-pip libpython3-dev ncdu openssl perl python python3-dev software-properties-common zip gnupg-agent
# curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
# apt-get install -y nodejs
# curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
# echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
# sudo apt-get update && sudo apt-get install yarn -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update && sudo apt install docker-ce -y
usermod -aG docker ubuntu
apt-get clean && sudo apt autoremove --purge && sudo apt-get autoclean
docker run -d -p $PORT:8388 -p $PORT:8388/udp --restart="unless-stopped" -e METHOD="aes-256-cfb" -e PASSWORD=$PSWD -e ARGS="--reuse-port" shadowsocks/shadowsocks-libev:latest

echo "==========================================================================="
echo "Deployment completed. Please verify the result manually by trying to connect to the proxy using a Shadowsocks client."
read -p "Press enter to continue"
reboot
