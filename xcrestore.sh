#!/bin/sh

# Parse the command line input
source "lib/input.sh"

# If the app is already signed, there's nothing that needs to be done
./lib/verify_codesign.rb "$BINARY_PATH"
if [ $? -eq 0 ]; then
    echo "${GREEN}$BINARY_PATH is already signed.${NC}"
    exit 0
fi

# Ensure that the app has a signed copy that can be restored
# If the return code of the verify_codesign call is 0, then
# we have a legitimately signed binary.
./lib/verify_codesign.rb "$SIGNED_PATH"
if [ ! $? -eq 0 ]; then
    echo "${RED}There no file at ${SIGNED_PATH} to restore.${NC}"
    exit 1
fi

# Delete the existing binary, and replace it with the signed copy
echo "Setting $BINARY_PATH to signed copy"
rm "$BINARY_PATH"
cp -p "$SIGNED_PATH" "$BINARY_PATH"
echo "${GREEN}Xcode $INPUT_VERSION has been re-signed.${NC}"

# Restore Xcode's app icon to the standard icon
./bin/fileicon rm $XCODE_PATH
killall Finder
killall Dock