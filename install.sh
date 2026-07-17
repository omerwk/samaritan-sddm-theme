#!/bin/bash

green='\e[0;32m'

# if catches any errors, stops
set -e 

# where the theme will be installed
THEME_DIR="/usr/share/sddm/themes/samaritan"

echo -e "${green}Installing Samaritan SDDM theme..."

# create theme directory
sudo mkdir -p "$THEME_DIR"
# copy the theme to the directory 
sudo cp -r ./* "$THEME_DIR"

# gets system information 
echo -e "${green}Generating SystemInfo.js..."
# cd into scripts folder to run them
cd "$THEME_DIR/scripts"
# make all of them exectutable
chmod +x *.sh
# and then execute this one to write the SystemInfo.js file
./update-system-info.sh

# make sddm use samaritan as the theme
cd
if grep -q "^Current=" /etc/sddm.conf; then
    sudo sed -i 's/^Current=.*/Current=samaritan/' /etc/sddm.conf
else
    sudo echo -e "[Theme]\nCurrent=samaritan" > /etc/sddm.conf
fi

# installation successful announcement
echo -e "${green}Samaritan theme was installed successfully!"

echo -e "${green}You can preview the theme now by running:\nsddm-greeter --test-mode --theme /usr/share/sddm/samaritan/"