#!/bin/bash
# This script installs the requirements for the Helix installation.

clear				# clear terminal window

echo "Updating Ubuntu"
echo

sudo apt -y update
sudo apt -y upgrade

echo "Ubuntu is updated!"
