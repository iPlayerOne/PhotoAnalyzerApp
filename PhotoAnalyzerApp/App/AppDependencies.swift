import SwiftData

final class AppDependencies {
    private let modelContainer: ModelContainer

    let imageNameGenerator: ImageNameGenerator
    let faceDetectionService: FaceDetectionService
    let photoOrientationDetector: PhotoOrientationDetector
    let imageStorageService: LocalImageStorageService

    init(
        modelContainer: ModelContainer,
        imageNameGenerator: ImageNameGenerator = ImageNameGenerator(),
        faceDetectionService: FaceDetectionService = VisionFaceDetectionService(),
        photoOrientationDetector: PhotoOrientationDetector = PhotoOrientationDetector(),
        imageStorageService: LocalImageStorageService = FileSystemImageStorageService()
    ) {
        self.modelContainer = modelContainer
        self.imageNameGenerator = imageNameGenerator
        self.faceDetectionService = faceDetectionService
        self.photoOrientationDetector = photoOrientationDetector
        self.imageStorageService = imageStorageService
    }
    
    @MainActor
    func makePhotoProjectRepository() -> PhotoProjectRepository {
        SwiftDataPhotoProjectRepository(
            modelContext: modelContainer.mainContext,
            imageStorageService: imageStorageService,
            orientationDetector: photoOrientationDetector
        )
    }
}
