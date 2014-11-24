#!/bin/sh

echo "Default keychain is $(security default)"

export APP_KEYCHAIN="ios-$APP_NAME-build.keychain"

# Create a custom keychain
security create-keychain -p $KEY_PASSWORD $APP_KEYCHAIN

# Make the custom keychain default, so xcodebuild will use it for signing
security default -s $APP_KEYCHAIN

echo "Default keychain is $(security default)"

# Unlock the keychain
security unlock-keychain -p $KEY_PASSWORD $APP_KEYCHAIN

# Set keychain timeout to 1 hour for long builds
# see http://www.egeek.me/2013/02/23/jenkins-and-xcode-user-interaction-is-not-allowed/
security -v set-keychain-settings -t 3600 -l ~/Library/Keychains/$APP_KEYCHAIN

# Add certificates to keychain and allow codesign to access them
security -v import ./scripts/certs/apple.cer -k ~/Library/Keychains/$APP_KEYCHAIN -T /usr/bin/codesign
security -v import ./scripts/certs/dist.cer -k ~/Library/Keychains/$APP_KEYCHAIN -T /usr/bin/codesign
security -v import ./scripts/certs/dist.p12 -k ~/Library/Keychains/$APP_KEYCHAIN -P $KEY_PASSWORD -T /usr/bin/codesign
