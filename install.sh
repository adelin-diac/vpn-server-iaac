#!/bin/bash

echo "Running setup script..."
echo ""

echo "Cloning repo..."
git clone https://github.com/adelin-diac/vpn-server-iaac.git
cd vpn-server-iaac
echo ""

echo "Installing docker..."
sudo ./scripts/setup-docker.sh --add-user "$(whoami)"
echo ""

# Things that can be automatic:
# - Port Forwarding (using upnp)
# - Assign static IP to server
# - DDNS - script to update DNS A Record, and Cron job
