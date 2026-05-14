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
        GeometryReader { proxy in
            ZStack {
                Color.black.opacity(0.55)
                    .ignoresSafeArea()
                    .onTapGesture {
                        onClose()
                    }

                VStack(spacing: 0) {
                    Spacer()

                    VStack(spacing: 20) {
                        imageContent(containerSize: proxy.size)
                        titleRow
                    }

                    Spacer()

                    if showExport {
                        PrimaryButton(
                            title: AppStrings.Button.export,
                            isDisabled: false
                        ) {
                            onExport()
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 44)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

extension ProcessingPhotoOverlayView {
    @ViewBuilder
    private func imageContent(containerSize: CGSize) -> some View {
        switch processingState {
        case .processing:
            skeletonPlaceholder(size: skeletonSize(in: containerSize))

        case .ready, .idle, .failed:
            processedImage(containerSize: containerSize)
        }
    }

    private func skeletonPlaceholder(size: CGSize) -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.85))
            .frame(width: size.width, height: size.height)
    }

    @ViewBuilder
    private func processedImage(containerSize: CGSize) -> some View {
        if let uiImage = UIImage(data: imageData) {
            let maxSize = imageMaxSize(in: containerSize)
            let size = imageDisplaySize(
                for: uiImage,
                maxWidth: maxSize.width,
                maxHeight: maxSize.height
            )

            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: size.width, height: size.height)
                .clipped()
        } else {
            skeletonPlaceholder(size: skeletonSize(in: containerSize))
        }
    }
    
    private var titleRow: some View {
        HStack(spacing: 10) {
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.white)
                .lineLimit(1)
            
            ProcessingStatusView(state: processingState)
        }
    }

    private func skeletonSize(in containerSize: CGSize) -> CGSize {
        let maxSize = imageMaxSize(in: containerSize)
        let width = min(maxSize.width, 260)
        let height = min(width * 1.38, maxSize.height)

        return CGSize(width: width, height: height)
    }

    private func imageMaxSize(in containerSize: CGSize) -> CGSize {
        let availableWidth = max(containerSize.width - 48, 1)
        let availableHeight = max(containerSize.height * 0.56, 1)

        return CGSize(
            width: min(availableWidth, 300),
            height: min(availableHeight, 420)
        )
    }

    private func imageDisplaySize(
        for image: UIImage,
        maxWidth: CGFloat,
        maxHeight: CGFloat
    ) -> CGSize {
        let imageWidth = max(image.size.width, 1)
        let imageHeight = max(image.size.height, 1)
        let aspectRatio = imageWidth / imageHeight

        if aspectRatio > 1 {
            let width = maxWidth
            let height = min(width / aspectRatio, maxHeight)

            return CGSize(width: width, height: height)
        } else {
            let height = maxHeight
            let width = min(height * aspectRatio, maxWidth)

            return CGSize(width: width, height: height)
        }
    }
}

#Preview {
    let sampleImage = UIImage(systemName: "photo")!
    let data = sampleImage.pngData()!
    return ProcessingPhotoOverlayView(imageData: data,title: "Processing", processingState: .ready(hasFace: true ), onClose: {}, onExport: {})
    
}
