# JavaScript Plugin Container for Swift

[English](README.md) | [한국어](README-ko.md)

## Overview
The JavaScript Plugin Container is a Swift-based library designed to facilitate communication between Swift applications and JavaScript code within WKWebViews. It allows for a structured and dynamic approach to handle JavaScript calls within Swift by leveraging a plugin architecture.

## Features
- Dynamic plugin management for JavaScript interfaces.
- Easy integration with WKWebView.
- Support for macOS, iOS, watchOS, and tvOS platforms.
- Debug utilities for plugin scanning and management.

## Requirements
- iOS 13.0+
- Swift 5.10

## Installation
To integrate the JavaScript Plugin Container into your project, copy the provided `.swift` files directly into your project or create a Swift Package:

### Swift Package Manager
You can add this library as a dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/minsOne/JSInterfacePluginContainer-iOS.git", from: "1.0.0")
]
```

## Usage

### Defining a Plugin
Implement the `JSInterfacePluginType` protocol with your custom plugin classes:

```swift
class MyPlugin: JSInterfacePlugin {
    var action: String { "myAction" }

    func callAsAction(_ message: [String: Any], with webView: WKWebView) {
        // Handle the action
    }
}
```

### Managing Plugins
Create an instance of `JSInterfaceSupervisor` and manage your plugins:

```swift
let supervisor = JSInterfaceSupervisor()
let myPlugin = MyPlugin()
supervisor.loadPlugin(myPlugin)
```

### Resolving Actions
Use the `resolve` function to handle incoming JavaScript calls:

```swift
supervisor.resolve("myAction", message: ["key": "value"], with: webView)
```

## Debugging
The library includes debugging aids that are active with the DEBUG flag. These aids can help identify registered plugins and ensure proper setup.

## Contributing
Contributions to the JavaScript Plugin Container are welcome. Here are ways you can contribute:
- Reporting issues
- Suggesting enhancements
- Submitting pull requests with bug fixes or new features

Please ensure to follow the coding standards and write tests for new functionality.

## License
Specify your licensing details here. For open-source projects, an MIT License is a common choice.

## Reference

* GitHub
  * [Electrode-iOS/ELMaestro](https://github.com/Electrode-iOS/ELMaestro)
