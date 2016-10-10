# xcunsign/xcrestore

<img width="180px" src="./resources/readme_XcodeUnsigned.png" />

## About

`xcunsign` and `xcrestore` are two scripts that allow for easy swapping between signed and unsigned copies of Xcode.

## Why?

Xcode 8 disables the ability to run 3rd party plugins (such as [Alcatraz]), in favor of providing an official extensions API ([WWDC: Using and Extending the Xcode Source Editor](https://developer.apple.com/videos/play/wwdc2016/414/)). This is a great thing for security and preventing the next [XcodeGhost 👻](https://en.wikipedia.org/wiki/XcodeGhost), and it sounds like the Xcode engineers want to provide the extension points that the community is asking for. However, only the source editor extension is available right now, which means that some of our favorite plugins are disabled until official support becomes available.

## Security

In light of the security benefits of using a signed Xcode, I would recommend swapping back to the signed version before any deployment builds are generated. These scripts can be integrated with [fastlane](https://fastlane.tools) to ensure that all deployemnt builds are generated from the signed Xcode, while you continue to use the unsigned version for access to plugins during development.

Fastlane has an action called `verify_xcode` which can be run as part of your `Fastfile` to ensure that the Xcode being used for the build is properly signed.

## Installation

To install the scripts, clone or download the repo, and then you can choose one of the following:

1. Call the scripts directly
2. Add the repo directory to your PATH
3. Symlink the scripts into a directory in your path
    
    ```
    ln -s <repo_directory>/xcunsign /usr/local/bin/xcunsign
    ln -s <repo_directory>/xcrestore /usr/local/bin/xcrestore
    ``` 

## Usage

To unsign, call the script, passing in the version of Xcode that you want to unsign. The script will find the copy of Xcode in the `/Applications` directory with that version, run [`unsign`](https://github.com/steakknife/unsign) on it, and keep a copy of the original signed binary that can be used to restore later. It also modifies Xcode's icon to indicate whether the app is currently signed or not.

```
xcunsign 8.0
```
 
To restore the signed binary, `Xcode` will be restored to the original binary that was present before the unsigned copy was created.

 ```
xcrestore 8.0
```


## Benefits of xcunsign

The reason I created this as an alternative to other approaches I have seen is that this allows me to swap quickly between signed and unsigned installations without needing to maintain two full copies of Xcode.app. The only thing that gets swapped out when the scripts are run is the `Xcode` binary within the Xcode.app container.


## Roadmap

- If there is only one version of Xcode installed, it shouldn't be necessary to pass in the version.
- Implement a fastlane plugin to xcrestore before the build 

## Credits

Special thanks to [steakknife's unsign](https://github.com/steakknife/unsign) and [mklement0's fileicon](https://github.com/mklement0/fileicon).

## License

MIT
