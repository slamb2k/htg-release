#!/bin/bash

INSTALL_DIR=service-monitor
HOME_DIR=/home/htc
HOST_NAME="tv-display-1"

# Delete the previous app folder in home directory
rm $HOME_DIR/$INSTALL_DIR -f -R -v -d

# Create new app folder in home directory
mkdir -p $HOME_DIR/$INSTALL_DIR

# Update sources and existing packages
#apt-get update
#apt-get upgrade -y

# Install curl for retrieving additional files and unzip for decompression
apt-get install -y curl
apt-get install -y unzip

# Get the necessary files from the github repo
curl -i -L https://github.com/slamb2k/htg-release/raw/main/service-monitor-deploy.zip -o $HOME_DIR/$INSTALL_DIR/service-monitor-deploy.zip
unzip $HOME_DIR/$INSTALL_DIR/service-monitor-deploy.zip -d $HOME_DIR/$INSTALL_DIR/

# Install nodejs 19.x with npm
curl -fsSL https://deb.nodesource.com/setup_19.x | bash - &&\
apt-get install -y nodejs

# Install all required dependencies
npm install --prefix $HOME_DIR/$INSTALL_DIR/

# Install the browser and xdotool for automating it
apt-get install -y xdotool
apt-get install -y chromium-browser

# Clean out any previous startup commands
sudo sed '/^nohup node/d' ~/.bashrc > ~/.bashrc

# Ensure the display runs on startup with this command:
echo "nohup node $HOME_DIR/$INSTALL_DIR/serviceChecker.js &>/dev/null &" >>$HOME_DIR/.bashrc

# Update the device's host name so it is unique
# and restart so it takes effect
if [ $HOSTNAME != $HOST_NAME ]
then
    echo "Renaming host to $HOST_NAME"
    hostnamectl set-hostname $HOST_NAME
    reboot
fi

