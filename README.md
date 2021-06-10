## Build

### Prerequisite

* Xcode 14.2 (or later)
* iOS 15.5 (or later)

Please make sure you have the following tools installed with `brew`:

* `brew install swiftlint`

The project has an external dependency on ***Wavecell.xcframework***:

* https://github.com/8x8Cloud/voice-sdk-ios/releases

Download  and unzip framework to:

* `SampleApp/Frameworks`

### Xcode IDE

1. Open **SampleApp.xcodeproj** in Xcode
2. Build & Run

**Note:** **SampleApp.xcodeproj** is configured with `xcconfig` files:

* `SampleApp/Configurations/`

## Voice SDK

The **SampleApp** project integrates the SDK via **WavecellClient** object.

