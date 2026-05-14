import Foundation
import SwiftData

@Model
final class PhotoProjectEntity {
    var id: UUID
    var title: String
    var fileName: String
    var hasFace: Bool
    var orientationRawValue: String
    var createdAt: Date
    
    init(
        id: UUID,
        title: String,
        fileName: String,
        hasFace: Bool,
        orientation: PhotoOrientation,
        createdAt: Date
    ) {
        self.id = id
        self.title = title
        self.fileName = fileName
        self.hasFace = hasFace
        self.orientationRawValue = orientation.rawValue
        self.createdAt = createdAt
    }
}

extension PhotoProjectEntity {
    var orientation: PhotoOrientation {
        PhotoOrientation(rawValue: orientationRawValue) ?? .square
    }
}
