import CoreGraphics
import Foundation
import ImageIO

struct PhotoOrientationDetector {
    func detectOrientation(from imageData: Data) -> PhotoOrientation {
        guard
            let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
            let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
            let width = (properties[kCGImagePropertyPixelWidth] as? NSNumber)?.doubleValue,
            let height = (properties[kCGImagePropertyPixelHeight] as? NSNumber)?.doubleValue
        else {
            return .square
        }
        
        return PhotoOrientation(
            size: visualSize(
                width: width,
                height: height,
                orientation: imageOrientation(from: properties)
            )
        )
    }
    
    private func imageOrientation(from properties: [CFString: Any]) -> CGImagePropertyOrientation {
        guard let rawValue = (properties[kCGImagePropertyOrientation] as? NSNumber)?.uint32Value else {
            return .up
        }
        
        return CGImagePropertyOrientation(rawValue: rawValue) ?? .up
    }
    
    private func visualSize(
        width: Double,
        height: Double,
        orientation: CGImagePropertyOrientation
    ) -> CGSize {
        switch orientation {
        case .left, .right, .leftMirrored, .rightMirrored:
            return CGSize(width: height, height: width)
        default:
            return CGSize(width: width, height: height)
        }
    }
}
