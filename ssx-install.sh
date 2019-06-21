#!/bin/bash

# Parse command line parameters
while [[ $# -gt 0 ]]; do
    arg="$1"

    case $arg in
        -p|--password)
            PSWD=$2
            shift
            ;;
        *)
            echo "[Error] Unrecognized option $1"
            exit 1
            ;;
    esac
    shift
done

echo "Please answer with Y or Yes to any prompts you may get."

apt update && sudo apt upgrade -y
apt remove --purge *4.15.0-1021* *4.15.0-1040* *lxd*
update-grub && sudo update-grub2 && sudo update-initramfs -u
apt install apparmor-utils apt-transport-https bash ca-certificates curl dbus git gnupg2 jq python3-pip libpython3-dev libpython-dev ncdu openssl perl python python3-dev software-properties-common zip gnupg-agent
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
apt-get install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update && sudo apt install docker-ce -y
usermod -aG docker ubuntu
apt-get clean && sudo apt autoremove --purge && sudo apt-get autoclean
docker run -d -p 80:8388 -p 80:8388/udp --restart="unless-stopped" -e TIMEOUT=600 -e METHOD="aes-256-cfb" -e PASSWORD=$PSWD -e ARGS="--reuse-port" shadowsocks/shadowsocks-libev
