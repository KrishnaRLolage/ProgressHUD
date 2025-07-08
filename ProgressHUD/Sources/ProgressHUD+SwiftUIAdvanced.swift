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

// MARK: - Advanced SwiftUI Integration Examples

/// A SwiftUI View that demonstrates async operations with ProgressHUD
@available(iOS 13.0, *)
public struct AsyncOperationView: View {
    @Environment(\.progressHUD) var progressHUD
    @State private var isLoading = false
    @State private var operationResult: String? = nil
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("Async Operation Demo")
                .font(.title2)
                .fontWeight(.semibold)
            
            if let result = operationResult {
                Text(result)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
                Button("Simulate Download") {
                    simulateDownload()
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)
                
                Button("Simulate Upload") {
                    simulateUpload()
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)
                
                Button("Simulate Network Error") {
                    simulateNetworkError()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .disabled(isLoading)
            }
        }
        .padding()
    }
    
    private func simulateDownload() {
        isLoading = true
        operationResult = nil
        
        progressHUD.animate("Downloading...", .horizontalDotScaling)
        
        // Simulate progress updates
        let progressValues: [Float] = [0.2, 0.4, 0.6, 0.8, 1.0]
        
        for (index, progress) in progressValues.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index + 1) * 0.8) {
                progressHUD.progress("Downloading... \(Int(progress * 100))%", progress)
                
                if progress == 1.0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        progressHUD.succeed("Download completed!", delay: 2.0)
                        operationResult = "✅ File downloaded successfully"
                        isLoading = false
                    }
                }
            }
        }
    }
    
    private func simulateUpload() {
        isLoading = true
        operationResult = nil
        
        progressHUD.animate("Uploading...", symbol: "icloud.and.arrow.up")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            progressHUD.succeed("Upload completed!", delay: 2.0)
            operationResult = "✅ File uploaded successfully"
            isLoading = false
        }
    }
    
    private func simulateNetworkError() {
        isLoading = true
        operationResult = nil
        
        progressHUD.animate("Connecting...", .circleRotateChase)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let error = NSError(domain: "NetworkError", code: 500, userInfo: [
                NSLocalizedDescriptionKey: "Server temporarily unavailable"
            ])
            progressHUD.failed(error, delay: 3.0)
            operationResult = "❌ Network operation failed"
            isLoading = false
        }
    }
}

/// A reusable SwiftUI component that wraps a view with loading state
@available(iOS 13.0, *)
public struct LoadingWrapper<Content: View>: View {
    @Binding var isLoading: Bool
    let loadingText: String
    let animationType: AnimationType
    let content: Content
    
    public init(
        isLoading: Binding<Bool>,
        loadingText: String = "Loading...",
        animationType: AnimationType = .activityIndicator,
        @ViewBuilder content: () -> Content
    ) {
        self._isLoading = isLoading
        self.loadingText = loadingText
        self.animationType = animationType
        self.content = content()
    }
    
    public var body: some View {
        content
            .animatedHUD(
                isShowing: $isLoading,
                text: loadingText,
                animationType: animationType
            )
    }
}

/// A SwiftUI binding extension for easier ProgressHUD integration
@available(iOS 13.0, *)
public extension Binding where Value == Bool {
    func progressHUD(
        text: String? = nil,
        animationType: AnimationType = .activityIndicator
    ) -> Binding<Bool> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                if newValue {
                    ProgressHUD.animate(text, animationType)
                } else {
                    ProgressHUD.dismiss()
                }
                self.wrappedValue = newValue
            }
        )
    }
}

/// A ViewModel example that integrates ProgressHUD with Combine
@available(iOS 13.0, *)
public class NetworkOperationViewModel: ObservableObject {
    @Published public var isLoading = false
    @Published public var progress: Float = 0.0
    @Published public var statusMessage = ""
    @Published public var lastError: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private let progressHUD = ProgressHUDState()
    
    public init() {}
    
    public func performOperation() {
        isLoading = true
        statusMessage = "Starting operation..."
        
        progressHUD.animate("Processing...", .circlePulseMultiple)
        
        // Simulate a network operation with progress
        Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .scan(0.0) { current, _ in current + 0.2 }
            .sink { [weak self] progressValue in
                guard let self = self else { return }
                
                self.progress = Float(progressValue)
                
                if progressValue <= 1.0 {
                    self.progressHUD.progress("Processing... \(Int(progressValue * 100))%", Float(progressValue))
                } else {
                    self.completeOperation()
                }
            }
            .store(in: &cancellables)
    }
    
    private func completeOperation() {
        cancellables.removeAll()
        
        // Simulate success or failure
        let isSuccess = Bool.random()
        
        if isSuccess {
            progressHUD.succeed("Operation completed!", delay: 2.0)
            statusMessage = "✅ Operation completed successfully"
        } else {
            let error = NSError(domain: "OperationError", code: 1001, userInfo: [
                NSLocalizedDescriptionKey: "Operation failed unexpectedly"
            ])
            lastError = error
            progressHUD.failed(error, delay: 2.0)
            statusMessage = "❌ Operation failed"
        }
        
        isLoading = false
        progress = 0.0
    }
}

/// A SwiftUI view that demonstrates the ViewModel integration
@available(iOS 13.0, *)
public struct NetworkOperationView: View {
    @StateObject private var viewModel = NetworkOperationViewModel()
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("Network Operation Demo")
                .font(.title2)
                .fontWeight(.semibold)
            
            if !viewModel.statusMessage.isEmpty {
                Text(viewModel.statusMessage)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if viewModel.isLoading {
                ProgressView("Progress: \(Int(viewModel.progress * 100))%", value: viewModel.progress)
                    .progressViewStyle(.linear)
                    .frame(width: 200)
            }
            
            Button("Start Network Operation") {
                viewModel.performOperation()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading)
        }
        .padding()
    }
}
