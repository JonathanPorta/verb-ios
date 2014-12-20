#!/bin/sh

# Save path to current keychain so that we can restore it properly during cleanup.
echo "Remembering the current default keychain: $ORIGINAL_KEYCHAIN"

# An absolute path really cut down on confusion and made a couple mistakes obvious.
mkdir -p /tmp/

export APP_KEYCHAIN="/tmp/ios-$APP_NAME-build.keychain"

# Create a custom keychain
security create-keychain -p $KEY_PASSWORD $APP_KEYCHAIN

# Put the custom keychain in our search list so xctool can find it.
security list-keychains -s $APP_KEYCHAIN
security default-keychain -s $APP_KEYCHAIN

# Unlock the keychain
security unlock-keychain -p $KEY_PASSWORD $APP_KEYCHAIN

# Set keychain timeout to 1 hour for long builds
# see http://www.egeek.me/2013/02/23/jenkins-and-xcode-user-interaction-is-not-allowed/
security set-keychain-settings -t 3600 -l $APP_KEYCHAIN

# Add certificates to keychain and allow codesign + xctool to access them.
# xctool requires access because it has to sign the framework dependencies before the rest of the app compiles.
security import ./scripts/certs/apple.cer -k $APP_KEYCHAIN -T /usr/bin/codesign -T /usr/local/bin/xctool
security import ./scripts/certs/dist.cer -k $APP_KEYCHAIN -T /usr/bin/codesign -T /usr/local/bin/xctool
security import ./scripts/certs/dist.p12 -k $APP_KEYCHAIN -P $KEY_PASSWORD -T /usr/bin/codesign -T /usr/local/bin/xctool
