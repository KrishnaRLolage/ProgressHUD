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

@available(iOS 13.0, *)
struct ProgressHUDSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withProgressHUD() // Enable ProgressHUD environment support
        }
    }
}

@available(iOS 13.0, *)
struct ContentView: View {
    var body: some View {
        TabView {
            SwiftUIDemo()
                .tabItem {
                    Image(systemName: "play.circle")
                    Text("Basic Demo")
                }
            
            AsyncOperationView()
                .tabItem {
                    Image(systemName: "arrow.down.circle")
                    Text("Async Operations")
                }
            
            NetworkOperationView()
                .tabItem {
                    Image(systemName: "network")
                    Text("Network Demo")
                }
            
            CustomizationView()
                .tabItem {
                    Image(systemName: "paintbrush")
                    Text("Customization")
                }
        }
    }
}

@available(iOS 13.0, *)
struct CustomizationView: View {
    @Environment(\.progressHUD) var progressHUD
    
    @State private var selectedColorScheme: ColorScheme? = nil
    @State private var hudBackgroundColor = Color.black.opacity(0.8)
    @State private var hudTextColor = Color.white
    @State private var animationSpeed: Double = 1.0
    @State private var showCustomHUD = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Appearance") {
                    ColorPicker("HUD Background", selection: $hudBackgroundColor)
                    ColorPicker("Text Color", selection: $hudTextColor)
                    
                    Picker("Color Scheme", selection: $selectedColorScheme) {
                        Text("System").tag(ColorScheme?.none)
                        Text("Light").tag(ColorScheme?.some(.light))
                        Text("Dark").tag(ColorScheme?.some(.dark))
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Animation") {
                    VStack(alignment: .leading) {
                        Text("Animation Speed: \(animationSpeed, specifier: "%.1f")x")
                        Slider(value: $animationSpeed, in: 0.5...2.0, step: 0.1)
                    }
                }
                
                Section("Test Customization") {
                    Button("Show Custom HUD") {
                        applyCustomization()
                        showCustomHUD = true
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Reset to Defaults") {
                        resetToDefaults()
                    }
                    .buttonStyle(.bordered)
                }
                
                Section("Banner Customization") {
                    Button("Custom Success Banner") {
                        customizeBanner()
                        progressHUD.succeed("Custom styling applied!", delay: 3.0)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    
                    Button("Custom Error Banner") {
                        customizeBanner()
                        progressHUD.failed("This is a custom error message!", delay: 3.0)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
            .navigationTitle("Customization")
        }
        .preferredColorScheme(selectedColorScheme)
        .animatedHUD(
            isShowing: $showCustomHUD,
            text: "Custom styled HUD!",
            animationType: .circlePulseMultiple
        )
        .onChange(of: showCustomHUD) { showing in
            if showing {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showCustomHUD = false
                }
            }
        }
    }
    
    private func applyCustomization() {
        // Apply custom colors
        ProgressHUD.colorHUD = UIColor(hudBackgroundColor)
        ProgressHUD.colorStatus = UIColor(hudTextColor)
        ProgressHUD.colorAnimation = UIColor(hudTextColor)
        
        // Apply custom fonts
        ProgressHUD.fontStatus = .systemFont(ofSize: 16, weight: .medium)
        
        // Apply animation speed (if available in the library)
        // Note: This might need to be implemented in the core library
    }
    
    private func customizeBanner() {
        ProgressHUD.colorBanner = UIColor.systemPurple.withAlphaComponent(0.9)
        ProgressHUD.colorBannerTitle = UIColor.white
        ProgressHUD.colorBannerMessage = UIColor.white.withAlphaComponent(0.8)
        ProgressHUD.fontBannerTitle = .boldSystemFont(ofSize: 18)
        ProgressHUD.fontBannerMessage = .systemFont(ofSize: 14)
    }
    
    private func resetToDefaults() {
        ProgressHUD.colorHUD = .systemBackground
        ProgressHUD.colorStatus = .label
        ProgressHUD.colorAnimation = .systemBlue
        ProgressHUD.fontStatus = .systemFont(ofSize: 15, weight: .medium)
        
        // Reset banner colors
        ProgressHUD.colorBanner = .clear
        ProgressHUD.colorBannerTitle = .label
        ProgressHUD.colorBannerMessage = .secondaryLabel
        ProgressHUD.fontBannerTitle = .boldSystemFont(ofSize: 16)
        ProgressHUD.fontBannerMessage = .systemFont(ofSize: 14)
        
        // Reset state variables
        hudBackgroundColor = Color.black.opacity(0.8)
        hudTextColor = Color.white
        animationSpeed = 1.0
        selectedColorScheme = nil
    }
}

#if DEBUG
@available(iOS 13.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
