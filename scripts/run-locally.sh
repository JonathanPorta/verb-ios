#!/bin/sh

echo "Settings Bundle Data"
./scripts/set-bundle.sh

echo "Build"
xctool -workspace Verb.xcworkspace -scheme Verb-travis -sdk iphoneos -configuration Release OBJROOT=$PWD/build SYMROOT=$PWD/build ONLY_ACTIVE_ARCH=NO

echo "Sign and Upload Build"
./scripts/sign-build.sh
