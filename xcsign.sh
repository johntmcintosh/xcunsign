#!/bin/sh

# Any error will fail the script
set -e

# Parse the command line input
source "lib/input.sh"

# Ensure that the app has a signed copy that can be restored
# Note: our check for signing is basic and is just checking to see
# that the *.signed copy of the binary is present in the directory.
# We're not actually investigating the signature on the binary.
if [ ! -f $SIGNED_PATH ]; then
    echo "${RED}There no file at ${SIGNED_PATH} to restore.${NC}"
    exit 1
fi

# Delete the existing binary, and replace it with the signed copy
echo "Setting $BINARY_PATH to signed copy"
rm "$BINARY_PATH"
cp -p "$SIGNED_PATH" "$BINARY_PATH"
echo "${GREEN}Xcode $INPUT_VERSION has been re-signed.${NC}"
