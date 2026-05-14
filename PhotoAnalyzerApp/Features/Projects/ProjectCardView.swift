import SwiftUI

struct ProjectCardView: View {
    let imageID: String
    let title: String
    let hasFace: Bool
    let orientation: PhotoOrientation
    let onTap: () -> Void
    
    @Environment(\.displayScale) private var displayScale
    @Environment(\.imageDecodeService) private var imageDecodeService
    @State private var thumbnailImage: UIImage?
    
    var body: some View {
        Button(action: onTap) {
            GeometryReader { proxy in
                ZStack(alignment: .bottomLeading) {
                    imageContent
                        .frame(width: proxy.size.width, height: orientation.cardHeight)
                        .clipped()
                    
                    HStack {
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Image(systemName: hasFace ? "person.crop.circle" : "photo")
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.black.opacity(0.6), .clear],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                }
                .frame(width: proxy.size.width, height: orientation.cardHeight)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            }
            .frame(height: orientation.cardHeight)
            .clipped()
        }
        .buttonStyle(.plain)
        .task(id: imageID) {
            guard let imageData else {
                thumbnailImage = nil
                return
            }

            let decoder = imageDecodeService
            let scale = displayScale
            let maxDimension = max(orientation.cardHeight, 220)

            thumbnailImage = await Task.detached(priority: .userInitiated) {
                autoreleasepool {
                    decoder.downsample(
                        maxDimension: maxDimension,
                        scale: scale
                    )
                }
            }.value
        }
    }
    
    @ViewBuilder
    private var imageContent: some View {
        if let thumbnailImage {
            Image(uiImage: thumbnailImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.gray.opacity(0.25))
        }
    }
}

private extension PhotoOrientation {
    var cardHeight: CGFloat {
        switch self {
            case .landscape:
                return 170
            case .portrait:
                return 280
            case .square:
                return 220
        }
    }
}

#Preview {
    ProjectCardView(
        imageID: "",
        title: "Sample Project",
        hasFace: true,
        orientation: .portrait,
        onTap: {}
    )
}
