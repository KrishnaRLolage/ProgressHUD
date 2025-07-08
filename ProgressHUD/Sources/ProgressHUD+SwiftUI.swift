//
// Copyright (c) 2025 Related Code - https://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SwiftUI
import Combine

// MARK: - SwiftUI Progress State
@available(iOS 13.0, *)
public class ProgressHUDState: ObservableObject {
    @Published public var isShowing: Bool = false
    @Published public var text: String? = nil
    @Published public var progress: Float? = nil
    @Published public var animationType: AnimationType = .activityIndicator
    @Published public var symbol: String? = nil
    @Published public var image: UIImage? = nil
    @Published public var interaction: Bool = true
    @Published public var delay: TimeInterval? = nil
    
    public init() {}
    
    // MARK: - Progress Methods
    public func show(_ text: String? = nil, interaction: Bool = true) {
        DispatchQueue.main.async {
            self.text = text
            self.interaction = interaction
            self.isShowing = true
            ProgressHUD.progress(text, interaction: interaction)
        }
    }
    
    public func progress(_ text: String? = nil, _ progress: Float, interaction: Bool = true) {
        DispatchQueue.main.async {
            self.text = text
            self.progress = progress
            self.interaction = interaction
            self.isShowing = true
            ProgressHUD.progress(text, progress, interaction: interaction)
        }
    }
    
    // MARK: - Animation Methods
    public func animate(_ text: String? = nil, _ type: AnimationType = .activityIndicator, interaction: Bool = true) {
        DispatchQueue.main.async {
            self.text = text
            self.animationType = type
            self.interaction = interaction
            self.isShowing = true
            ProgressHUD.animate(text, type, interaction: interaction)
        }
    }
    
    public func animate(_ text: String? = nil, symbol: String, interaction: Bool = true) {
        DispatchQueue.main.async {
            self.text = text
            self.symbol = symbol
            self.interaction = interaction
            self.isShowing = true
            ProgressHUD.animate(text, symbol: symbol, interaction: interaction)
        }
    }
    
    // MARK: - Live Icon Methods
    public func succeed(_ text: String? = nil, interaction: Bool = true, delay: TimeInterval? = nil) {
        DispatchQueue.main.async {
            self.text = text
            self.interaction = interaction
            self.delay = delay
            self.isShowing = true
            ProgressHUD.succeed(text, interaction: interaction, delay: delay)
            
            if let delay = delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.isShowing = false
                }
            }
        }
    }
    
    public func failed(_ text: String? = nil, interaction: Bool = true, delay: TimeInterval? = nil) {
        DispatchQueue.main.async {
            self.text = text
            self.interaction = interaction
            self.delay = delay
            self.isShowing = true
            ProgressHUD.failed(text, interaction: interaction, delay: delay)
            
            if let delay = delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.isShowing = false
                }
            }
        }
    }
    
    public func failed(_ error: Error?, interaction: Bool = true, delay: TimeInterval? = nil) {
        DispatchQueue.main.async {
            self.text = error?.localizedDescription
            self.interaction = interaction
            self.delay = delay
            self.isShowing = true
            ProgressHUD.failed(error, interaction: interaction, delay: delay)
            
            if let delay = delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.isShowing = false
                }
            }
        }
    }
    
    public func added(_ text: String? = nil, interaction: Bool = true, delay: TimeInterval? = nil) {
        DispatchQueue.main.async {
            self.text = text
            self.interaction = interaction
            self.delay = delay
            self.isShowing = true
            ProgressHUD.added(text, interaction: interaction, delay: delay)
            
            if let delay = delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.isShowing = false
                }
            }
        }
    }
    
    // MARK: - Static Image Methods
    public func image(_ text: String? = nil, image: UIImage?, interaction: Bool = true, delay: TimeInterval? = nil) {
        DispatchQueue.main.async {
            self.text = text
            self.image = image
            self.interaction = interaction
            self.delay = delay
            self.isShowing = true
            ProgressHUD.image(text, image: image, interaction: interaction, delay: delay)
            
            if let delay = delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.isShowing = false
                }
            }
        }
    }
    
    public func symbol(_ text: String? = nil, name: String, interaction: Bool = true, delay: TimeInterval? = nil) {
        DispatchQueue.main.async {
            self.text = text
            self.symbol = name
            self.interaction = interaction
            self.delay = delay
            self.isShowing = true
            ProgressHUD.symbol(text, name: name, interaction: interaction, delay: delay)
            
            if let delay = delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.isShowing = false
                }
            }
        }
    }
    
    public func success(_ text: String? = nil, image: UIImage? = nil, interaction: Bool = true, delay: TimeInterval? = nil) {
        DispatchQueue.main.async {
            self.text = text
            self.image = image
            self.interaction = interaction
            self.delay = delay
            self.isShowing = true
            ProgressHUD.success(text, image: image, interaction: interaction, delay: delay)
            
            if let delay = delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.isShowing = false
                }
            }
        }
    }
    
    public func error(_ text: String? = nil, image: UIImage? = nil, interaction: Bool = true, delay: TimeInterval? = nil) {
        DispatchQueue.main.async {
            self.text = text
            self.image = image
            self.interaction = interaction
            self.delay = delay
            self.isShowing = true
            ProgressHUD.error(text, image: image, interaction: interaction, delay: delay)
            
            if let delay = delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.isShowing = false
                }
            }
        }
    }
    
    public func error(_ error: Error?, image: UIImage? = nil, interaction: Bool = true, delay: TimeInterval? = nil) {
        DispatchQueue.main.async {
            self.text = error?.localizedDescription
            self.image = image
            self.interaction = interaction
            self.delay = delay
            self.isShowing = true
            ProgressHUD.error(error, image: image, interaction: interaction, delay: delay)
            
            if let delay = delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.isShowing = false
                }
            }
        }
    }
    
    // MARK: - Hide Methods
    public func dismiss() {
        DispatchQueue.main.async {
            self.isShowing = false
            ProgressHUD.dismiss()
        }
    }
    
    public func remove() {
        DispatchQueue.main.async {
            self.isShowing = false
            ProgressHUD.remove()
        }
    }
}

// MARK: - SwiftUI View Modifiers
@available(iOS 13.0, *)
public extension View {
    
    /// Displays a progress HUD with the specified configuration
    func progressHUD(isShowing: Binding<Bool>,
                    text: String? = nil,
                    interaction: Bool = true) -> some View {
        self.onChange(of: isShowing.wrappedValue) { showing in
            if showing {
                ProgressHUD.progress(text, interaction: interaction)
            } else {
                ProgressHUD.dismiss()
            }
        }
    }
    
    /// Displays a progress HUD with progress value
    func progressHUD(isShowing: Binding<Bool>,
                    text: String? = nil,
                    progress: Float,
                    interaction: Bool = true) -> some View {
        self.onChange(of: isShowing.wrappedValue) { showing in
            if showing {
                ProgressHUD.progress(text, progress, interaction: interaction)
            } else {
                ProgressHUD.dismiss()
            }
        }
        .onChange(of: progress) { newProgress in
            if isShowing.wrappedValue {
                ProgressHUD.progress(text, newProgress, interaction: interaction)
            }
        }
    }
    
    /// Displays an animated HUD
    func animatedHUD(isShowing: Binding<Bool>,
                    text: String? = nil,
                    animationType: AnimationType = .activityIndicator,
                    interaction: Bool = true) -> some View {
        self.onChange(of: isShowing.wrappedValue) { showing in
            if showing {
                ProgressHUD.animate(text, animationType, interaction: interaction)
            } else {
                ProgressHUD.dismiss()
            }
        }
    }
    
    /// Displays an animated HUD with SF Symbol
    func symbolHUD(isShowing: Binding<Bool>,
                  text: String? = nil,
                  symbol: String,
                  interaction: Bool = true) -> some View {
        self.onChange(of: isShowing.wrappedValue) { showing in
            if showing {
                ProgressHUD.animate(text, symbol: symbol, interaction: interaction)
            } else {
                ProgressHUD.dismiss()
            }
        }
    }
    
    /// Displays a success HUD with auto-dismiss
    func successHUD(isShowing: Binding<Bool>,
                   text: String? = nil,
                   image: UIImage? = nil,
                   interaction: Bool = true,
                   delay: TimeInterval = 2.0) -> some View {
        self.onChange(of: isShowing.wrappedValue) { showing in
            if showing {
                ProgressHUD.success(text, image: image, interaction: interaction, delay: delay)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    isShowing.wrappedValue = false
                }
            }
        }
    }
    
    /// Displays an error HUD with auto-dismiss
    func errorHUD(isShowing: Binding<Bool>,
                 text: String? = nil,
                 image: UIImage? = nil,
                 interaction: Bool = true,
                 delay: TimeInterval = 2.0) -> some View {
        self.onChange(of: isShowing.wrappedValue) { showing in
            if showing {
                ProgressHUD.error(text, image: image, interaction: interaction, delay: delay)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    isShowing.wrappedValue = false
                }
            }
        }
    }
    
    /// Displays an error HUD with Error object
    func errorHUD(isShowing: Binding<Bool>,
                 error: Error?,
                 image: UIImage? = nil,
                 interaction: Bool = true,
                 delay: TimeInterval = 2.0) -> some View {
        self.onChange(of: isShowing.wrappedValue) { showing in
            if showing {
                ProgressHUD.error(error, image: image, interaction: interaction, delay: delay)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    isShowing.wrappedValue = false
                }
            }
        }
    }
    
    /// Displays a banner notification
    func bannerHUD(isShowing: Binding<Bool>,
                  title: String? = nil,
                  message: String? = nil,
                  delay: TimeInterval = 3.0) -> some View {
        self.onChange(of: isShowing.wrappedValue) { showing in
            if showing {
                ProgressHUD.banner(title, message, delay: delay)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    isShowing.wrappedValue = false
                }
            } else {
                ProgressHUD.bannerHide()
            }
        }
    }
}

// MARK: - SwiftUI Environment Integration
@available(iOS 13.0, *)
public struct ProgressHUDEnvironmentKey: EnvironmentKey {
    public static let defaultValue = ProgressHUDState()
}

@available(iOS 13.0, *)
public extension EnvironmentValues {
    var progressHUD: ProgressHUDState {
        get { self[ProgressHUDEnvironmentKey.self] }
        set { self[ProgressHUDEnvironmentKey.self] = newValue }
    }
}

// MARK: - Convenience SwiftUI Views
@available(iOS 13.0, *)
public struct ProgressHUDWrapper<Content: View>: View {
    @StateObject private var hudState = ProgressHUDState()
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .environment(\.progressHUD, hudState)
    }
}

@available(iOS 13.0, *)
public extension View {
    /// Wraps the view with ProgressHUD environment support
    func withProgressHUD() -> some View {
        ProgressHUDWrapper {
            self
        }
    }
}
