import SwiftUI

struct ProcessingStatusView: View {
    let state: PhotoProcessingState
    
    var body: some View {
        switch state {
        case .idle:
            EmptyView()
        case .processing:
            ProgressView()
                .controlSize(.small)
        case .ready(let hasFace):
            Image(systemName: hasFace ? "faceid" : "photo")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color("AccentMint"))
        case .failed:
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.yellow)
        }
    }
}

#Preview {
    ProcessingStatusView(state: .ready(hasFace: true))
}
