# Run the following command to install the service monitor. It will be installed in the home directory of the user 'htc' and will be run on startup. Attributes of the install can be overridden by setting environment variables before running the command.
#
# curl -s https://ggle.io/htc-display | sudo -E bash -
#

#!/bin/bash

EXPORT ${HOST_NAME:=tv-display-1}
EXPORT ${HOME_DIR:=/home/htc}
EXPORT ${INSTALL_DIR:=service-monitor}
EXPORT ${DISPLAY_URL:=http://192.168.0.230:3000/}

# Delete the previous app folder in home directory
rm $HOME_DIR/$INSTALL_DIR -f -R cat -d

# Create new app folder in home directory
mkdir -p $HOME_DIR/$INSTALL_DIR

# Update sources and existing packages
apt-get update
apt-get upgrade -y

# Install curl for retrieving additional files and unzip for decompression
apt-get install -y curl
apt-get install -y unzip

# Get the necessary files from the github repo
curl -i -L https://github.com/slamb2k/htg-release/raw/main/service-monitor-deploy.zip -o $HOME_DIR/$INSTALL_DIR/service-monitor-deploy.zip
unzip $HOME_DIR/$INSTALL_DIR/service-monitor-deploy.zip -d $HOME_DIR/$INSTALL_DIR/

# Set shell scripts to be executable
chmod +x $HOME_DIR/$INSTALL_DIR/*.sh

# Install nodejs 19.x with npm
curl -fsSL https://deb.nodesource.com/setup_19.x | bash - &&\
apt-get install -y nodejs

# Install all required dependencies
npm install --prefix $HOME_DIR/$INSTALL_DIR/

# Install the browser and xdotool for automating it
apt-get install -y xdotool
apt-get install -y chromium-browser

# Ensure the display runs on startup by loading the browser
cat > $HOME_DIR/.config/autostart/browser.desktop<< EOF
[Desktop Entry]
Exec=env DISPLAY_URL=$DISPLAY_URL $HOME_DIR/$INSTALL_DIR/run-chromium.sh
EOF

# Update the device's host name so it is unique
# and restart so it takes effect
if [ $HOSTNAME != $HOST_NAME ]
then
    echo "Renaming host to $HOST_NAME"
    hostnamectl set-hostname $HOST_NAME
fi

reboot now

