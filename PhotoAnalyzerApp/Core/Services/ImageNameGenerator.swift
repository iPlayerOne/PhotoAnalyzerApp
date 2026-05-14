import Foundation

final class ImageNameGenerator {
    private let baseNames: [String] = [
        "Sunset", "Mountain", "Beach", "Forest", "Cityscape",
        "Portrait", "Pet", "Food", "Flower", "Building",
        "Lake", "Art", "Landscape", "Tree", "Cloud",
        "River", "Snow", "Sand", "Road", "Horizon"
    ]
    
    func generateName(existingCount: Int) -> String {
        let name = baseNames.randomElement() ?? "Image"
        let index = existingCount + 1
        
        return "\(name)-\(index)"
    }
}
