#!/bin/sh

# Any error will fail the script
set -e

# Parse the command line input
source "lib/input.sh"

# If the app has not been unsigned yet, unsign it
# Note: our check for signing is basic and is just checking to see
# that the *.unsigned copy of the binary is present in the directory.
# We're not actually investigating the signature on the binary.
if [ ! -f $UNSIGNED_PATH ]; then
    echo "It looks like the app has not been unsigned yet."
    echo "Copying standard binary to $SIGNED_PATH"
    `cp $BINARY_PATH $SIGNED_PATH`

    echo "Executing unsign now..."
    echo `unsign $BINARY_PATH $UNSIGNED_PATH`
fi

# Delete the existing binary, and replace it with the unsigned copy
echo "Setting $BINARY_PATH to unsigned copy"
rm "$BINARY_PATH"
cp -p "$UNSIGNED_PATH" "$BINARY_PATH"
echo "${GREEN}Xcode $INPUT_VERSION has been unsigned.${NC}"
