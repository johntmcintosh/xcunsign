#!/bin/sh

# Any error will fail the script
set -e

source "lib/helpers.sh"

# Require an input version to be passed as the first parameter to the script.
INPUT_VERSION=$1
if [ -z $INPUT_VERSION ]; then
    echo "${RED}No version argument supplied.${NC}"
	echo "Please pass the desired Xcode version as an input parameter. For example './xcunsign.sh 8.0'"
    echo "TODO: Update this to use the current Xcode version if there is only one."
	exit 1
fi

# Get the path to the specified version of Xcode
XCODE_PATH=`xcode_app_path_for_version $INPUT_VERSION`
if [ -z $XCODE_PATH ]; then
	exit 1
fi
echo "Xcode version $INPUT_VERSION found in $XCODE_PATH"

# Setup the paths that we'll be using
BINARY_PATH="$XCODE_PATH/Contents/MacOS/Xcode"
SIGNED_PATH="$BINARY_PATH.signed"
UNSIGNED_PATH="$BINARY_PATH.unsigned"

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
