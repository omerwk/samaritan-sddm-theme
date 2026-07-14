#!/bin/bash

# if catches any errors, stops
set -e 

# where the theme will be installed
THEME_DIR="/usr/share/sddm/themes/samaritan"

echo "Installing Samaritan SDDM theme..."

sudo mkdir -p "$THEME_DIR"
sudo cp -r ./* "$THEME_DIR"

# gets system information 
echo "Generating SystemInfo.js..."
cd "$THEME_DIR/scripts"
chmod +x *.sh
./update-system-info.sh

echo "Samaritan theme was installed successfully!"