import Foundation
import SwiftData

final class AppDependency {
    let imageNameGenerator: ImageNameGenerator
    let faceDetectionService: FaceDetectionService
    let photoOrientationDetector: PhotoOrientationDetector
    let imageStorageService: LocalImageStorageService
    
    private let modelContainer: ModelContainer
    
    init(
        modelContainer: ModelContainer,
        imageNameGenerator: ImageNameGenerator = ImageNameGenerator(),
        faceDetectionService: FaceDetectionService = FaceDetectionServiceImpl(),
        photoOrientationDetector: PhotoOrientationDetector = PhotoOrientationDetector(),
        imageStorageService: LocalImageStorageService = LocalImageStorageServiceImpl()
    ) {
        self.modelContainer = modelContainer
        self.imageNameGenerator = imageNameGenerator
        self.faceDetectionService = faceDetectionService
        self.photoOrientationDetector = photoOrientationDetector
        self.imageStorageService = imageStorageService
    }
    
    @MainActor
    func makePhotoProjectRepository() -> PhotoProjectRepository {
        PhotoProjectRepositoryImpl(
            modelContext: modelContainer.mainContext,
            imageStorageService: imageStorageService,
            orientationDetector: photoOrientationDetector
        )
    }

}
