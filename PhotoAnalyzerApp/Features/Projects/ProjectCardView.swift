import SwiftUI

struct ProjectCardView: View {
    let imageData: Data?
    let title: String
    let hasFace: Bool
    let orientation: PhotoOrientation
    let onTap: () -> Void
    
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
    }
    
    @ViewBuilder
    private var imageContent: some View {
        if let imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
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
        imageData: nil,
        title: "Sample Project",
        hasFace: true,
        orientation: .portrait,
        onTap: {}
    )
}
