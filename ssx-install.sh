#!/bin/bash

ARCH=$(uname -m)

# Parse command line parameters
while [[ $# -gt 0 ]]; do
    arg="$1"

    case $arg in
        -p|--port)
            PORT=$2
            shift
            ;;
        -k|--password)
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

# Generate hardware options
case $ARCH in
    "x86_64")
        MACHINE=amd64
    ;;
    "armv7l")
        MACHINE=armhf
    ;;
    "aarch64")
        MACHINE=arm64
    ;;
    *)
        echo "[Error] $ARCH not supported!"
        exit 1
    ;;
esac

if [ -z $PORT ]; then
    PORT=8388
fi
if [ -z $PSWD ]; then
    PSWD=ShdwSoxPrxy
fi


echo "Welcome to this convenience script by Mohammed Saleh"
echo "===================================================="
echo "This script is specifically made for 64-bit Ubuntu/Debian Linux on intel/AMD systems."
echo "It is not suitable for ARM systems such as Raspberry Pi."
echo "The purpose of this script is to deploy a Shadowsocks proxy server, usually on a VPS such as Amazon Lightsail or DigitalOcean."
echo "Please make sure to open the same port you choose for this server on both TCP and UDP protocols (from your instance/droplet/firewall settings), and also set an external STATIC IP for the server."
echo "========================================================================="
sleep 10

apt update && sudo apt upgrade -y
# apt remove --purge *4.15.0-1021* *4.15.0-1040* *lxd*
# update-grub && sudo update-grub2 && sudo update-initramfs -u
apt install -y apparmor-utils apt-transport-https bash ca-certificates curl dbus git gnupg2 jq python3-pip libpython3-dev ncdu openssl perl python python3-dev software-properties-common zip gnupg-agent
# curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
# apt-get install -y nodejs
# curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
# echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
# sudo apt-get update && sudo apt-get install yarn -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=$MACHINE] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update && sudo apt install docker-ce -y
usermod -aG docker ubuntu
# apt-get clean && sudo apt autoremove --purge && sudo apt-get autoclean
docker run -d -p $PORT:8388 -p $PORT:8388/udp --restart="unless-stopped" -e METHOD="aes-256-cfb" -e PASSWORD=$PSWD -e ARGS="--reuse-port" shadowsocks/shadowsocks-libev:latest

echo "==========================================================================="
echo "Deployment completed. Please verify the result manually by trying to connect to the proxy using a Shadowsocks client."
echo "Server will now reboot!"
sleep 10
reboot
