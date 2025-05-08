# AppScreenshotKit

AppScreenshotKit is a Swift package that automates the creation of App Store screenshots for iOS and iPadOS applications. It helps streamline the process of generating high-quality, consistent screenshots across all device types.

## Features

- 📱 **Multi-device Support**: Compatible with all iOS/iPadOS devices including iPhone SE, iPhone 15/16 series, iPad, and more
- 🖼️ **App Store Compliant**: Generates screenshots at the proper resolutions for App Store submission
- 🧩 **Flexible Customization**: Customize screenshot content with a simple API
- 🔄 **Batch Processing**: Generate screenshots for all device types at once
- 💻 **Cross-platform**: Works on both macOS and iOS
- 🌐 **Localization Support**: Generate screenshots for multiple locales

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file's dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/AppScreenshotKit.git", from: "1.0.0")
]
```

## Usage

### Basic Usage

1. Create a screenshot generator class:

```swift
import AppScreenshotKit

struct MyAppScreenshots: AppScreenshot {
    // Use default configuration (iPhone 16 Pro)
    // or specify your own:
    static let configuration = AppScreenshotConfiguration(
        .iPhone69Inch(),
        .iPad130Inch()
    )
    
    @MainActor
    static func body(environment: AppScreenshotEnvironment) -> some View {
        ZStack {
            // Background
            Color.blue.opacity(0.2).ignoresSafeArea()
            
            VStack {
                Text("My Awesome App")
                    .font(.largeTitle)
                    .padding()
                
                // Display app screen in device bezel
                DeviceView {
                    // Your actual app screen UI goes here
                    VStack {
                        Text("App Screen")
                        Image(systemName: "star.fill")
                            .font(.system(size: 80))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                }
                .frame(height: 500)
                
                Text("Try our amazing features!")
                    .padding()
            }
        }
    }
}
```

2. Generate screenshots:

```swift
// Generate screenshots
do {
    let screenshots = try await MyAppScreenshots.export()
    // Process or save the screenshots
} catch {
    print("Error generating screenshots: \(error)")
}
```

### Preview During Development

Use SwiftUI previews to test your screenshots:

```swift
#Preview {
    MyAppScreenshots.preview()
}

// Or with device bezel
#Preview {
    MyAppScreenshots.bezelPreview()
}
```

## Customization

### Device Configuration

Various device types and color variations are supported:

```swift
// iPhone 16 Pro Max (Titanium Black)
let deviceConfig = AppScreenshotConfiguration(
    .iPhone69Inch(
        color: .blackTitanium,
        orientation: .portrait
    )
)

// iPad Pro 13-inch (Space Gray, landscape)
let iPadConfig = AppScreenshotConfiguration(
    .iPad130Inch(
        color: .spaceGray,
        orientation: .landscape
    )
)
```

### Multi-locale and Multiple Screenshots

Generate screenshots for multiple locales or create a series of screenshots:

```swift
// Create 2 screenshots in both Japanese and English locales
let config = AppScreenshotConfiguration(
    .iPhone69Inch(),
    .iPad130Inch()
)
.locales([Locale(identifier: "ja_JP"), Locale(identifier: "en_US")])
.count(2)
```

## Sample Project

The package includes `SampleScreenshotGenerator` which can be used as a demo of the functionality.

## Requirements

- iOS 16.0+ / macOS 13.0+
- Swift 5.9+
- Xcode 15.0+

## License

Available under the MIT license. See the LICENSE file for more information.