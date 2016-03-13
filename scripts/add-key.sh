#!/bin/sh

KEY_CHAIN=ios-build.keychain
security create-keychain -p travis $KEY_CHAIN
# Make the keychain the default so identities are found
security default-keychain -s $KEY_CHAIN
# Unlock the keychain
security unlock-keychain -p travis $KEY_CHAIN
# Set keychain locking timeout to 3600 seconds
security set-keychain-settings -t 3600 -u $KEY_CHAIN

security import ./scripts/certs/apple.cer -k $KEY_CHAIN -T /usr/bin/codesign
security import ./scripts/certs/dist.cer -k $KEY_CHAIN -T /usr/bin/codesign
security import ./scripts/certs/dist.p12 -k $KEY_CHAIN -P $KEY_PASSWORD -T /usr/bin/codesign
echo "Add keychain to keychain-list"
security find-identity -p codesigning $KEY_CHAIN

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./scripts/profile/$PROFILE_NAME.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
echo $PROFILE_NAME