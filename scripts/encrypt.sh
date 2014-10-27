#!/bin/sh
echo "Encrypting your certs and profile"
openssl aes-256-cbc -k $ENCRYPTION_SECRET -in ./scripts/profile/$PROFILE_NAME.mobileprovision -out ./scripts/profile/$PROFILE_NAME.mobileprovision.enc -a
openssl aes-256-cbc -k $ENCRYPTION_SECRET -in ./scripts/certs/dist.cer -out ./scripts/certs/dist.cer.enc -a
openssl aes-256-cbc -k $ENCRYPTION_SECRET -in ./scripts/certs/dist.p12 -out ./scripts/certs/dist.p12.enc -a
