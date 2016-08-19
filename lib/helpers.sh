# Common helper functions for working with Xcode versions 

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Echo list of all installed Xcode versions 
list_installed_xcode_versions() {
	for i in /Applications/Xcode* 
	do 
	VERSION=`mdls -name kMDItemVersion "$i" | sed 's/kMDItemVersion = /Xcode /g' | sed 's/"//g'`
	echo $VERSION >&2
	done
}

# Echo path to Xcode version matching the version provided in the first calling argument
xcode_app_path_for_version () {
	TARGET_VERSION=$1
	
	for i in /Applications/Xcode* 
	do 
	VERSION=`mdls -name kMDItemVersion "$i" | sed 's/kMDItemVersion = //g' | sed 's/"//g'`
	if [ $VERSION == $TARGET_VERSION ]; then
		echo $i
		return
	fi	
	done
	
    local RED='\033[0;31m'
    local NC='\033[0m' # No Color
	echo "${RED}Unable to find an Xcode version matching: $TARGET_VERSION${NC}" >&2
	echo "Installed versions:" >&2; list_installed_xcode_versions
	return 1
}
