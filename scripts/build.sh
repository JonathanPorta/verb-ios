#!/bin/sh

set -e

echo "Beginning Build"
xctool -workspace Verb.xcworkspace -scheme Verb-travis -sdk iphoneos -configuration Release OBJROOT=$PWD/build SYMROOT=$PWD/build ONLY_ACTIVE_ARCH=NO CODE_SIGN_IDENTITY="$DEVELOPER_NAME" PROVISIONING_PROFILE=$PROFILE_UUID OTHER_CODE_SIGN_FLAGS="--keychain ~/Library/Keychains/$APP_KEYCHAIN"
