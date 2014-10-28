#!/bin/sh

# Put the provisioning profile in place
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp "./scripts/profile/$PROFILE_NAME.mobileprovision" ~/Library/MobileDevice/Provisioning\ Profiles/

echo "Settings Bundle Data"
./scripts/set-bundle.sh

echo "Build"
xctool -workspace Verb.xcworkspace -scheme Verb-travis -sdk iphoneos -configuration Release OBJROOT=$PWD/build SYMROOT=$PWD/build ONLY_ACTIVE_ARCH=NO

echo "Sign and Upload Build"
./scripts/sign-build.sh
