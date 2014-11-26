#!/bin/sh

set -e

# Figure out the UUID of our provisioning profile - http://stackoverflow.com/questions/10398456/can-an-xcode-mobileprovision-file-be-installed-from-the-command-line/10775025#10775025
export PROFILE_UUID=`grep UUID -A1 -a ./scripts/profile/$PROFILE_NAME.mobileprovision | grep -io "[-A-Z0-9]\{36\}"`

PROFILE_DIRECTORY="$HOME/Library/MobileDevice/Provisioning Profiles"
INSTALLED_PROFILE="$PROFILE_DIRECTORY/$PROFILE_UUID.mobileprovision"

# Put the provisioning profile in place
echo "Installing provisioning profile $PROFILE_NAME as $INSTALLED_PROFILE"
mkdir -p "$PROFILE_DIRECTORY"
cp "./scripts/profile/$PROFILE_NAME.mobileprovision" "$INSTALLED_PROFILE"
cp "./scripts/profile/$PROFILE_NAME.mobileprovision" "$PROFILE_DIRECTORY/$PROFILE_NAME.mobileprovision"
