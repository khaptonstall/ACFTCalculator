# ACFTCalculator

![](https://github.com/khaptonstall/acftcalculator/actions/workflows/ci.yml/badge.svg)
[![codecov](https://codecov.io/gh/khaptonstall/ACFTCalculator/branch/main/graph/badge.svg?token=9BSWQEXH2F)](https://codecov.io/gh/khaptonstall/ACFTCalculator)

ACFTCalculator is a tool, written in Swift, for calculating Army Combat Fitness Test scores.

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
Each ACFT event is represented by the `ACFTEvent` enum, where each case has a single associated value representing the value (meters, pounds, repetitions, etc.) recorded for that individual event.

After capturing a value for an individual event, you just need to create an instance of `ACFTCalculator` and use the `calculatePoints(event:)` method to obtain the number of points earned.
```swift
do {
    let calculator = try ACFTCalculator()
    
    // 3 Repetition Maxium Deadlift (MDL)
    _ = calculator.calculatePoints(for: .threeRepetitionMaximumDeadlift(pounds: 340))
    
    // Standing Power Throw (SPT)
    _ = calculator.calculatePoints(for: .standingPowerThrow(meters: 12.5))
    
    // Hand Release Push-Up - Arm Extension (HRP)
    _ = calculator.calculatePoints(for: .handReleasePushUp(repetitions: 60))
    
    // Sprint-Drag-Carry (SDC)
    _ = calculator.calculatePoints(for: .sprintDragCarry(time: RecordedTime(seconds: 93)))
    
    // Leg Tuck (LTK)
    _ = calculator.calculatePoints(for: .legTuck(repetitions: 20))
    
    // Plank (PLK)
    _ = calculator.calculatePoints(for: .plank(time: RecordedTime(seconds: 260)))
    
    // Two-Mile Run (2MR)
    _ = calculator.calculatePoints(for: .twoMileRun(time: RecordedTime(seconds: 810)))
} catch {
    print(error)
}
```

When working with events that use time (such as the Two-Mile Run), you'll have use the `RecordedTime` struct, which provides two options for initialization:
```swift
// Using RecordedTime(seconds:) creates a non-optional instance:
let recordedTime = RecordedTime(seconds: 60)

// Using RecordedTime(minutes:seconds:) creates an optional instance which returns nil when an invalid seconds value is provide (e.x. seconds > 59):
let nilRecordedTime = RecordedTime(minutes: 1, seconds: 100)
let validOptionalRecordedTime = RecordedTime(minutes: 1, seconds: 59)
```

## Resources
For more information on the Army Combat Fitness Test and individual events, see https://www.army.mil/acft/

The source used to calculate points for each ACFT event can be found at https://www.army.mil/e2/downloads/rv7/acft/acft_scoring_standards.pdf
