import Foundation
import SwiftData

@MainActor
protocol PhotoProjectRepository {
    func createProject(imageData: Data, title: String, hasFace: Bool) throws -> PhotoProjectEntity
}

@MainActor
final class SwiftDataPhotoProjectRepository: PhotoProjectRepository {
    private let modelContext: ModelContext
    private let imageStorageService: LocalImageStorageService
    private let orientationDetector: PhotoOrientationDetector
    
    init(
        modelContext: ModelContext,
        imageStorageService: LocalImageStorageService,
        orientationDetector: PhotoOrientationDetector
    ) {
        self.modelContext = modelContext
        self.imageStorageService = imageStorageService
        self.orientationDetector = orientationDetector
    }
    
    func createProject(imageData: Data, title: String, hasFace: Bool) throws -> PhotoProjectEntity {
        let fileName = "\(title).jpg"
        try imageStorageService.saveImage(data: imageData, fileName: fileName)
        
        let orientation = orientationDetector.detectOrientation(from: imageData)
        
        let project = PhotoProjectEntity(
            id: UUID(),
            title: title,
            fileName: fileName,
            hasFace: hasFace,
            orientation: orientation,
            createdAt: Date()
        )
        
        modelContext.insert(project)
        try modelContext.save()
        
        return project
    }
}
