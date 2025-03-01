#!/bin/bash

echo "Running setup script..."
echo ""

echo "Installing docker..."
sudo ./scripts/setup-docker.sh --add-user "$(whoami)"


# Things that can be automatic:
# - Port Forwarding (using upnp)
# - Assign static IP to server
# - DDNS - script to update DNS A Record, and Cron job
