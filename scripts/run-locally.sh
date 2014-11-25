#!/bin/sh

set -e

echo "Load local config"
source ./scripts/config.sh

echo "Creating Temporary Keychains"
./scripts/add-key.sh

echo "Install Provisioning Profile"
./scripts/install-provisioning-profile.sh

echo "Set Bundle Data"
./scripts/set-bundle.sh

echo "Run Build"
./scripts/build.sh

echo "Sign and Upload Build"
./scripts/sign-build.sh

echo "Cleanup"
./scripts/cleanup.sh
