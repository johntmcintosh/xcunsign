#!/bin/sh

# Parse the command line input
source "lib/input.sh"

# If the app is already unsigned, there's nothing that needs to be done
./lib/verify_codesign.rb "$BINARY_PATH"
if [ ! $? -eq 0 ]; then
    echo "${GREEN}$BINARY_PATH is already unsigned.${NC}"
    exit 0
fi

# If the app has not been unsigned yet, unsign it.
# NOTE: `ditto` is only available on macOS, and it allows us to do a
# copy, while creating any intermediate directories that do not exist.
echo "The app is currently signed."
echo "Copying standard binary to $SIGNED_PATH"
ditto $BINARY_PATH $SIGNED_PATH

echo "Executing unsign now..."
echo `unsign $BINARY_PATH $UNSIGNED_PATH`

# Delete the existing binary, and replace it with the unsigned copy
echo "Setting $BINARY_PATH to unsigned copy"
rm "$BINARY_PATH"
cp -p "$UNSIGNED_PATH" "$BINARY_PATH"
echo "${GREEN}Xcode $INPUT_VERSION has been unsigned.${NC}"

# Set Xcode's app icon to the unsigned icon
./bin/fileicon set $XCODE_PATH ./resources/XcodeUnsigned.png
killall Finder
killall Dock
