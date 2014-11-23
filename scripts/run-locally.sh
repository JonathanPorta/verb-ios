#!/bin/sh

set -e

# Put the provisioning profile in place
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
UUID=`grep UUID -A1 -a ./scripts/profile/$PROFILE_NAME.mobileprovision | grep -io "[-A-Z0-9]\{36\}"`
cp "./scripts/profile/$PROFILE_NAME.mobileprovision" ~/Library/MobileDevice/Provisioning\ Profiles/$UUID.mobileprovision

echo "Settings Bundle Data"
./scripts/set-bundle.sh

echo "Build"
xctool -workspace Verb.xcworkspace -scheme Verb-travis -sdk iphoneos -configuration Release OBJROOT=$PWD/build SYMROOT=$PWD/build ONLY_ACTIVE_ARCH=NO CODE_SIGN_IDENTITY="$DEVELOPER_NAME" PROVISIONING_PROFILE=

echo "Sign and Upload Build"
./scripts/sign-build.sh
