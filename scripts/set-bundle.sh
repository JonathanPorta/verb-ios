#!/bin/sh

echo "Saving Backup of $(pwd)/$INFO_PLIST to $(pwd)/$INFO_PLIST.bak"
cp "$INFO_PLIST" "$INFO_PLIST.bak"

echo "Updating Bundle"
if [ ! -z "$INFO_PLIST" ]; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $TRAVIS_BUILD_NUMBER" "$INFO_PLIST"
  echo "Set CFBundleVersion to $TRAVIS_BUILD_NUMBER"
fi

if [ ! -z "$BUNDLE_DISPLAY_NAME" ]; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $BUNDLE_DISPLAY_NAME" "$INFO_PLIST"
  echo "Set CFBundleDisplayName to $BUNDLE_DISPLAY_NAME"
fi
