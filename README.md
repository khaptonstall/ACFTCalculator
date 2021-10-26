# ACFTCalculator
ACFTCalculator is a tool, written in Swift, for calculating Army Combat Fitness Test scores.

🚧 ⚠️ This project is an active work-in-progress and is not yet considered "feature complete" to enable calculating points for every ACFT event. ⚠️ 🚧

## Installation
### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) is built into the Swift toolchain and is the preferred way of integrating.

For Swift package projects, simply add the following line to your `Package.swift` file in the `dependencies` section:

```swift
dependencies: [
  .package(url: "https://github.com/khaptonstall/ACFTCalculator", .upToNextMajor(from: "<version>")),
]
```

For app projects, simply follow the [Apple documentation](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) on adding package dependencies to your app.

## Usage 
TODO

## Resources
For more information on the Army Combat Fitness Test and individual events, see https://www.army.mil/acft/

The source used to calculate points for each ACFT event can be found at https://www.army.mil/e2/downloads/rv7/acft/acft_scoring_standards.pdf
