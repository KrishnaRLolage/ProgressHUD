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
struct SwiftUIDemo: View {
    @Environment(\.progressHUD) var progressHUD
    
    @State private var showProgress = false
    @State private var showAnimation = false
    @State private var showSuccess = false
    @State private var showError = false
    @State private var showBanner = false
    @State private var showSymbol = false
    
    @State private var progressValue: Float = 0.0
    @State private var selectedAnimation: AnimationType = .activityIndicator
    @State private var selectedSymbol: String = "heart.fill"
    
    var body: some View {
        NavigationView {
            List {
                // MARK: - Progress Section
                Section("Progress") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Progress: \(Int(progressValue * 100))%")
                            Spacer()
                            Slider(value: $progressValue, in: 0...1)
                                .frame(width: 120)
                        }
                        
                        Button("Show Progress") {
                            showProgress = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.vertical, 4)
                }
                
                // MARK: - Animation Section
                Section("Animations") {
                    VStack(alignment: .leading, spacing: 10) {
                        Picker("Animation Type", selection: $selectedAnimation) {
                            ForEach(AnimationType.allCases, id: \.self) { type in
                                Text(animationName(for: type))
                                    .tag(type)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Button("Show Animation") {
                            showAnimation = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.vertical, 4)
                }
                
                // MARK: - Symbol Section
                Section("SF Symbols") {
                    VStack(alignment: .leading, spacing: 10) {
                        Picker("Symbol", selection: $selectedSymbol) {
                            Text("❤️ heart.fill").tag("heart.fill")
                            Text("⭐ star.fill").tag("star.fill")
                            Text("🔥 flame.fill").tag("flame.fill")
                            Text("⚡ bolt.fill").tag("bolt.fill")
                            Text("🎯 target").tag("target")
                            Text("🚀 paperplane.fill").tag("paperplane.fill")
                        }
                        .pickerStyle(.menu)
                        
                        Button("Show Symbol Animation") {
                            showSymbol = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.vertical, 4)
                }
                
                // MARK: - Status Section
                Section("Status Messages") {
                    VStack(spacing: 8) {
                        Button("Show Success") {
                            showSuccess = true
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        
                        Button("Show Error") {
                            showError = true
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                    .padding(.vertical, 4)
                }
                
                // MARK: - Banner Section
                Section("Banner Notifications") {
                    Button("Show Banner") {
                        showBanner = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .padding(.vertical, 4)
                }
                
                // MARK: - Environment Methods Section
                Section("Environment Methods") {
                    VStack(spacing: 8) {
                        Button("Environment Progress") {
                            progressHUD.show("Loading with environment...")
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                progressHUD.dismiss()
                            }
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Environment Success") {
                            progressHUD.succeed("Success via environment!", delay: 2.0)
                        }
                        .buttonStyle(.bordered)
                        .tint(.green)
                        
                        Button("Environment Error") {
                            let error = NSError(domain: "Demo", code: 404, userInfo: [NSLocalizedDescriptionKey: "Resource not found"])
                            progressHUD.failed(error, delay: 2.0)
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                        
                        Button("Environment Animation") {
                            progressHUD.animate("Custom animation", .circlePulseMultiple)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                progressHUD.dismiss()
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(.purple)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("ProgressHUD SwiftUI")
            .navigationBarTitleDisplayMode(.large)
        }
        // MARK: - View Modifier Examples
        .progressHUD(isShowing: $showProgress, 
                    text: "Loading \(Int(progressValue * 100))%", 
                    progress: progressValue)
        
        .animatedHUD(isShowing: $showAnimation,
                    text: "Custom Animation",
                    animationType: selectedAnimation)
        
        .symbolHUD(isShowing: $showSymbol,
                  text: "Symbol Animation",
                  symbol: selectedSymbol)
        
        .successHUD(isShowing: $showSuccess,
                   text: "Operation completed successfully!",
                   delay: 2.0)
        
        .errorHUD(isShowing: $showError,
                 text: "Something went wrong!",
                 delay: 2.0)
        
        .bannerHUD(isShowing: $showBanner,
                  title: "SwiftUI Banner",
                  message: "This is a banner notification from SwiftUI!",
                  delay: 3.0)
        
        .onAppear {
            // Configure ProgressHUD appearance
            ProgressHUD.animationType = .activityIndicator
            ProgressHUD.colorHUD = .systemBackground
            ProgressHUD.colorBackground = .clear
            ProgressHUD.fontStatus = .systemFont(ofSize: 16, weight: .medium)
        }
    }
    
    private func animationName(for type: AnimationType) -> String {
        switch type {
        case .none: return "None"
        case .activityIndicator: return "Activity Indicator"
        case .ballVerticalBounce: return "Ball Vertical Bounce"
        case .barSweepToggle: return "Bar Sweep Toggle"
        case .circleArcDotSpin: return "Circle Arc Dot Spin"
        case .circleBarSpinFade: return "Circle Bar Spin Fade"
        case .circleDotSpinFade: return "Circle Dot Spin Fade"
        case .circlePulseMultiple: return "Circle Pulse Multiple"
        case .circlePulseSingle: return "Circle Pulse Single"
        case .circleRippleMultiple: return "Circle Ripple Multiple"
        case .circleRippleSingle: return "Circle Ripple Single"
        case .circleRotateChase: return "Circle Rotate Chase"
        case .circleStrokeSpin: return "Circle Stroke Spin"
        case .dualDotSidestep: return "Dual Dot Sidestep"
        case .horizontalBarScaling: return "Horizontal Bar Scaling"
        case .horizontalDotScaling: return "Horizontal Dot Scaling"
        case .pacmanProgress: return "Pacman Progress"
        case .quintupleDotDance: return "Quintuple Dot Dance"
        case .semiRingRotation: return "Semi Ring Rotation"
        case .sfSymbolBounce: return "SF Symbol Bounce"
        case .squareCircuitSnake: return "Square Circuit Snake"
        case .triangleDotShift: return "Triangle Dot Shift"
        }
    }
}

#if DEBUG
@available(iOS 13.0, *)
struct SwiftUIDemo_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIDemo()
            .withProgressHUD()
    }
}
#endif
