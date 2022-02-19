#!/bin/bash
# Moonraker Timelapse component installer
#
# Copyright (C) 2021 Christoph Frei <fryakatkop@gmail.com>
# Copyright (C) 2021 Stephan Wendel aka KwadFan <me@stephanwe.de>
#
# This file may be distributed under the terms of the GNU GPLv3 license.
#
# Note:
# this installer script is heavily inspired by 
# https://github.com/protoloft/klipper_z_calibration/blob/master/install.sh

# Force script to exit if an error occurs
set -e

# Default Parameters
KLIPPER_TARGET_DIR="${HOME}/klipper_config"

# Define text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/ && pwd )"

#zerog-mainsail-theme

function stop_klipper {
    if [ "$(sudo systemctl list-units --full -all -t service --no-legend | grep -F "klipper.service")" ]; then
        echo "Klipper service found! Stopping during Install."
        sudo systemctl stop klipper
    else
        echo "Klipper service not found, please install Klipper first"
        exit 1
    fi
}

function stop_moonraker {
    if [ "$(sudo systemctl list-units --full -all -t service --no-legend | grep -F "moonraker.service")" ]; then
        echo "Moonraker service found! Stopping during Install."
        sudo systemctl stop moonraker
    else
        echo "Moonraker service not found, please install Moonraker first"
        exit 1
    fi
}

function install_script {
# Create systemd service file
    THEME_FILES="${KLIPPER_TARGET_DIR}/.theme"
    #[ -f $THEME_FILES ] && return
    if [ -f $THEME_FILES ]; then
        # Force remove
        sudo rm -f "$THEME_FILES"
    fi

    echo "Installing theme..."
    cp -r "${SRCDIR}/.theme" ${KLIPPER_TARGET_DIR}
    cp -r "${SRCDIR}/.git" "${KLIPPER_TARGET_DIR}/.theme" 
    echo "theme installed, have fun!" << EOF
EOF
}


function restart_services {
    echo "Restarting Moonraker..."
    sudo systemctl restart moonraker
    echo "Restarting Klipper..."
    sudo systemctl restart klipper
}



### MAIN

# Parse command line arguments
while getopts "c:h" arg; do
    if [ -n "${arg}" ]; then
        case $arg in
            c)
                KLIPPER_CONFIG_DIR=$OPTARG
                break
            ;;
            [?]|h)
                echo -e "\nUsage: ${0} -c /path/to/klipper_config"
                exit 1
            ;;
        esac
    fi
    break
done

# Run steps
#stop_moonraker
#stop_klipper
#link_extension
install_script
#restart_services

# If something checks status of install
exit 0
