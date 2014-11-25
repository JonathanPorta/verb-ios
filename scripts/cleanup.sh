#!/bin/sh

echo "Deleting keychain $APP_KEYCHAIN"
security delete-keychain $APP_KEYCHAIN

echo "Uninstalling provisioning profile"
rm -f "~/Library/MobileDevice/Provisioning Profiles/$PROFILE_UUID.mobileprovision"

echo "Resetting $INFO_PLIST"
mv "$INFO_PLIST.bak" "$INFO_PLIST"
