import SwiftUI

struct ProcessingPhotoOverlayView: View {
    let imageData: Data
    let title: String
    let processingState: PhotoProcessingState
    let onClose: () -> Void
    let onExport: () -> Void
    
    private var showExport: Bool {
        if case .ready = processingState {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.30)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }
            VStack {
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    Image(systemName: "photo")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                        .frame(height: 260)
                }
                
                titleRow
                
                if case .failed(let message) = processingState {
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.yellow)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                }
                 
                if showExport {
                    Spacer()
                    PrimaryButton(
                        title: AppStrings.Button.export,
                        isDisabled: false) {
                            onExport()
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: 340)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.15))
            }
            .onTapGesture {
                
            }
        }
    }
}

extension ProcessingPhotoOverlayView {
    private var titleRow: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .lineLimit(1)
            
            ProcessingStatusView(state: processingState)
        }
    }
}

#Preview {
    let sampleImage = UIImage(systemName: "photo")!
    let data = sampleImage.pngData()!
    return ProcessingPhotoOverlayView(imageData: data,title: "Processing", processingState: .ready(hasFace: true ), onClose: {}, onExport: {})

}
