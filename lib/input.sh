# Common script for parsing the command line input and generating 
# the variables that will represent the paths for the signed
# and unsigned binaries.

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
