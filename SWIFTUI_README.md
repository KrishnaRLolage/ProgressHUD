# ProgressHUD SwiftUI Integration

This document describes how to use ProgressHUD with SwiftUI applications.

## Overview

The SwiftUI integration provides several ways to use ProgressHUD in your SwiftUI apps:

1. **View Modifiers** - Easy-to-use modifiers that you can attach to any SwiftUI view
2. **Environment Integration** - Access ProgressHUD through SwiftUI's environment system
3. **Observable State** - Use `ProgressHUDState` as an `@ObservableObject` for reactive programming
4. **Advanced Components** - Reusable components for common patterns

## Quick Start

### 1. Enable ProgressHUD Environment Support

Wrap your root view with the `withProgressHUD()` modifier:

```swift
import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withProgressHUD() // Enable ProgressHUD environment support
        }
    }
}
```

### 2. Basic Usage with View Modifiers

```swift
struct ContentView: View {
    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var progress: Float = 0.0
    
    var body: some View {
        VStack {
            Button("Start Loading") {
                isLoading = true
            }
            
            Button("Show Success") {
                showSuccess = true
            }
        }
        // Basic progress HUD
        .progressHUD(isShowing: $isLoading, text: "Loading...")
        
        // Progress HUD with progress bar
        .progressHUD(isShowing: $isLoading, text: "Downloading...", progress: progress)
        
        // Success HUD with auto-dismiss
        .successHUD(isShowing: $showSuccess, text: "Operation completed!", delay: 2.0)
        
        // Animated HUD with custom animation
        .animatedHUD(isShowing: $isLoading, 
                    text: "Processing...", 
                    animationType: .circlePulseMultiple)
        
        // Symbol HUD with SF Symbols
        .symbolHUD(isShowing: $isLoading, 
                  text: "Uploading...", 
                  symbol: "icloud.and.arrow.up")
    }
}
```

### 3. Environment-Based Usage

```swift
struct ContentView: View {
    @Environment(\.progressHUD) var progressHUD
    
    var body: some View {
        VStack {
            Button("Show Progress") {
                progressHUD.show("Loading from environment...")
                
                // Auto-dismiss after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    progressHUD.dismiss()
                }
            }
            
            Button("Show Success") {
                progressHUD.succeed("Success!", delay: 2.0)
            }
            
            Button("Show Error") {
                let error = NSError(domain: "MyApp", code: 404, 
                                  userInfo: [NSLocalizedDescriptionKey: "Resource not found"])
                progressHUD.failed(error, delay: 2.0)
            }
        }
    }
}
```

## Available View Modifiers

### Progress HUDs

```swift
// Basic progress HUD
.progressHUD(isShowing: Binding<Bool>, text: String?, interaction: Bool = true)

// Progress HUD with progress value
.progressHUD(isShowing: Binding<Bool>, text: String?, progress: Float, interaction: Bool = true)
```

### Animated HUDs

```swift
// Custom animation
.animatedHUD(isShowing: Binding<Bool>, 
            text: String?, 
            animationType: AnimationType = .activityIndicator, 
            interaction: Bool = true)

// SF Symbol animation
.symbolHUD(isShowing: Binding<Bool>, 
          text: String?, 
          symbol: String, 
          interaction: Bool = true)
```

### Status HUDs (Auto-dismissing)

```swift
// Success HUD
.successHUD(isShowing: Binding<Bool>, 
           text: String?, 
           image: UIImage? = nil, 
           interaction: Bool = true, 
           delay: TimeInterval = 2.0)

// Error HUD
.errorHUD(isShowing: Binding<Bool>, 
         text: String?, 
         image: UIImage? = nil, 
         interaction: Bool = true, 
         delay: TimeInterval = 2.0)

// Error HUD with Error object
.errorHUD(isShowing: Binding<Bool>, 
         error: Error?, 
         image: UIImage? = nil, 
         interaction: Bool = true, 
         delay: TimeInterval = 2.0)
```

### Banner Notifications

```swift
.bannerHUD(isShowing: Binding<Bool>, 
          title: String?, 
          message: String?, 
          delay: TimeInterval = 3.0)
```

## ProgressHUDState Methods

When using `@Environment(\.progressHUD)`, you have access to these methods:

### Progress Methods
- `show(_ text: String?, interaction: Bool = true)`
- `progress(_ text: String?, _ progress: Float, interaction: Bool = true)`

### Animation Methods
- `animate(_ text: String?, _ type: AnimationType = .activityIndicator, interaction: Bool = true)`
- `animate(_ text: String?, symbol: String, interaction: Bool = true)`

### Live Icon Methods
- `succeed(_ text: String?, interaction: Bool = true, delay: TimeInterval? = nil)`
- `failed(_ text: String?, interaction: Bool = true, delay: TimeInterval? = nil)`
- `failed(_ error: Error?, interaction: Bool = true, delay: TimeInterval? = nil)`
- `added(_ text: String?, interaction: Bool = true, delay: TimeInterval? = nil)`

### Static Image Methods
- `image(_ text: String?, image: UIImage?, interaction: Bool = true, delay: TimeInterval? = nil)`
- `symbol(_ text: String?, name: String, interaction: Bool = true, delay: TimeInterval? = nil)`
- `success(_ text: String?, image: UIImage? = nil, interaction: Bool = true, delay: TimeInterval? = nil)`
- `error(_ text: String?, image: UIImage? = nil, interaction: Bool = true, delay: TimeInterval? = nil)`

### Control Methods
- `dismiss()` - Hide the HUD
- `remove()` - Remove the HUD immediately

## Advanced Usage

### Async Operations

```swift
struct AsyncOperationView: View {
    @Environment(\.progressHUD) var progressHUD
    @State private var isLoading = false
    
    var body: some View {
        Button("Download File") {
            downloadFile()
        }
        .disabled(isLoading)
    }
    
    private func downloadFile() {
        isLoading = true
        progressHUD.animate("Downloading...", .horizontalDotScaling)
        
        // Simulate download progress
        let progressValues: [Float] = [0.2, 0.4, 0.6, 0.8, 1.0]
        
        for (index, progress) in progressValues.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index + 1) * 0.8) {
                progressHUD.progress("Downloading... \\(Int(progress * 100))%", progress)
                
                if progress == 1.0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        progressHUD.succeed("Download completed!", delay: 2.0)
                        isLoading = false
                    }
                }
            }
        }
    }
}
```

### Loading Wrapper Component

```swift
LoadingWrapper(isLoading: $isLoading, loadingText: "Please wait...") {
    // Your content here
    MyContentView()
}
```

### ViewModel Integration

```swift
class MyViewModel: ObservableObject {
    @Published var isLoading = false
    private let progressHUD = ProgressHUDState()
    
    func performOperation() {
        isLoading = true
        progressHUD.animate("Processing...")
        
        // Your async operation here
        someAsyncOperation { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.progressHUD.succeed("Success!", delay: 2.0)
                case .failure(let error):
                    self?.progressHUD.failed(error, delay: 2.0)
                }
            }
        }
    }
}
```

## Animation Types

All animation types from the original ProgressHUD library are supported:

- `.activityIndicator`
- `.ballVerticalBounce`
- `.barSweepToggle`
- `.circleArcDotSpin`
- `.circleBarSpinFade`
- `.circleDotSpinFade`
- `.circlePulseMultiple`
- `.circlePulseSingle`
- `.circleRippleMultiple`
- `.circleRippleSingle`
- `.circleRotateChase`
- `.circleStrokeSpin`
- `.dualDotSidestep`
- `.horizontalBarScaling`
- `.horizontalDotScaling`
- `.pacmanProgress`
- `.quintupleDotDance`
- `.semiRingRotation`
- `.sfSymbolBounce`
- `.squareCircuitSnake`
- `.triangleDotShift`

## Customization

You can customize the appearance using the existing ProgressHUD properties:

```swift
// Customize colors
ProgressHUD.colorHUD = .systemBackground
ProgressHUD.colorStatus = .label
ProgressHUD.colorAnimation = .systemBlue

// Customize fonts
ProgressHUD.fontStatus = .systemFont(ofSize: 16, weight: .medium)

// Customize banner
ProgressHUD.colorBanner = .systemPurple
ProgressHUD.colorBannerTitle = .white
ProgressHUD.fontBannerTitle = .boldSystemFont(ofSize: 18)
```

## Migration from UIKit

If you're migrating from UIKit usage to SwiftUI, the API remains mostly the same:

**UIKit:**
```swift
ProgressHUD.progress("Loading...")
ProgressHUD.succeed("Success!", delay: 2.0)
ProgressHUD.dismiss()
```

**SwiftUI (Environment):**
```swift
progressHUD.show("Loading...")
progressHUD.succeed("Success!", delay: 2.0)
progressHUD.dismiss()
```

**SwiftUI (View Modifiers):**
```swift
.progressHUD(isShowing: $isLoading, text: "Loading...")
.successHUD(isShowing: $showSuccess, text: "Success!", delay: 2.0)
```

## Requirements

- iOS 13.0+
- SwiftUI
- The SwiftUI integration is built on top of the existing UIKit ProgressHUD library

## Notes

- All ProgressHUD operations are automatically dispatched to the main queue
- View modifiers automatically handle the showing/hiding state
- Environment integration allows for centralized HUD management
- Auto-dismissing HUDs will automatically update the binding state
- The SwiftUI integration maintains full compatibility with the original UIKit API
