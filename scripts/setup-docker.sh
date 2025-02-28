#!/bin/bash

set -e

# Usage: install_docker.sh [--add-user USERNAME]
#
# This script installs Docker, Docker CLI, containerd, the buildx plugin,
# and the Docker Compose plugin (v2) on an Ubuntu system.
# Optionally, you can add a specified non-root user to the "docker" group
# by passing the "--add-user" flag.
#
# Example:
#   sudo ./install_docker.sh --add-user jim

usage() {
  echo "Usage: $0 [--add-user USERNAME]"
  exit 1
}

DOCKER_USER=""

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --add-user)
      shift
      if [ -z "$1" ]; then
        usage
      fi
      DOCKER_USER="$1"
      ;;
    *)
      usage
      ;;
  esac
  shift
done

# Ensure the script is run as root.
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

echo "Updating package index..."
apt-get update -y

echo "Installing prerequisites..."
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

echo "Removing any old Docker versions (if present)..."
apt-get remove -y docker docker-engine docker.io containerd runc || true

echo "Adding Docker's official GPG key..."
rm -f /etc/apt/keyrings/docker.gpg # Remove gpg key if it already exists
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

distro=$(lsb_release -cs)
echo "Setting up the Docker repository for ${distro}..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu ${distro} stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package index again..."
apt-get update -y

echo "Installing Docker Engine, CLI, containerd, buildx plugin, and Docker Compose plugin..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Docker installation completed."

echo "Docker Compose plugin version:"
docker compose version

# Add user to docker group if supplied
if [ -n "$DOCKER_USER" ]; then
  echo "Adding user '$DOCKER_USER' to the docker group..."
  usermod -aG docker "$DOCKER_USER"
  echo "User '$DOCKER_USER' has been added to the docker group."
  echo "Note: The user will need to log out and back in for the group membership to take effect."
fi

echo "Installation complete!"
