import CoreGraphics

enum PhotoOrientation: String, Codable {
    case landscape
    case portrait
    case square
    
    init(size: CGSize) {
        if size.width > size.height {
            self = .landscape
        } else if size.height > size.width {
            self = .portrait
        } else {
            self = .square
        }
    }
}

