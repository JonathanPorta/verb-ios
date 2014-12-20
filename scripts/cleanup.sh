#!/bin/sh

echo "Deleting keychain $APP_KEYCHAIN"
security delete-keychain $APP_KEYCHAIN

echo "Restoring original keychain to default $ORIGINAL_KEYCHAIN"
security list-keychain -s $ORIGINAL_KEYCHAIN
security default-keychain -s $ORIGINAL_KEYCHAIN

echo "Uninstalling provisioning profile"
rm -f "~/Library/MobileDevice/Provisioning Profiles/$PROFILE_UUID.mobileprovision"

echo "Resetting $INFO_PLIST"
mv "$INFO_PLIST.bak" "$INFO_PLIST"
