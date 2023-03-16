#!/bin/bash

INSTALL_DIR=service-monitor
HOME_DIR=/home/htc
HOST_NAME=tv-display-1

# Create new app folder in home directory
mkdir -p $HOME_DIR/$INSTALL_DIR

# Update sources and existing packages
#apt-get update
#apt-get upgrade -y

# Install curl for retrieving additional files
apt-get install -y curl

# Get the necessary files from the github repo
curl -i -L https://raw.githubusercontent.com/HTCDevelopment/htg-master/main/service-monitor/package.json?token=GHSAT0AAAAAACACGZ6PM7IHIFCYU4BMFP5IZASC3CQ -o $HOME_DIR/$INSTALL_DIR/package.json
curl -i -L https://raw.githubusercontent.com/HTCDevelopment/htg-master/main/service-monitor/serviceChecker.js?token=GHSAT0AAAAAACACGZ6OW5MROUTKGIY3EH5IZASC66Q -o $HOME_DIR/$INSTALL_DIR/serviceChecker.js
curl -i -L https://raw.githubusercontent.com/HTCDevelopment/htg-master/main/service-monitor/run-chromium.sh?token=GHSAT0AAAAAACACGZ6OEAVACXSCES626T5MZASC6AQ -o $HOME_DIR/$INSTALL_DIR/run-chromium.sh
chmod 755 $HOME_DIR/$INSTALL_DIR/run-chromium.sh

# Install nodejs 19.x with npm
curl -fsSL https://deb.nodesource.com/setup_19.x | bash - &&\
apt-get install -y nodejs

# Install all required dependencies
npm install --prefix $HOME_DIR/$INSTALL_DIR/

# Install the browser and xdotool for automating it
apt-get install -y xdotool
apt-get install -y chromium-browser

# Ensure the display runs on startup with this command:
# nohup node /home/htc/service-monitor/serviceChecker.js &>/dev/null &
#
#echo 'nohup node $HOME_DIR/$INSTALL_DIR/serviceChecker.js &>/dev/null &' >>$HOME_DIR/.bashrc

# Update the device's host name so it is unique
# and restart so it takes effect
if [$HOSTNAME != $HOST_NAME]; then
    echo "Renaming host to $HOST_NAME"
    hostnamectl set-hostname $HOST_NAME
    reboot
fi