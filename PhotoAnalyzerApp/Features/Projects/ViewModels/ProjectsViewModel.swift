import Foundation
import Observation

@MainActor
@Observable
final class ProjectsViewModel {
    private let nameGenerator: ImageNameGenerator
    private let faceDetectionService: FaceDetectionService
    private let imageStorageService: LocalImageStorageService
    private let repository: PhotoProjectRepository
    
    var selectedImageData: Data?
    var generatedTitle: String?
    var processingState: PhotoProcessingState = .idle
    
    var isOverlayPresented: Bool {
        selectedImageData != nil
    }
    
    init(
        nameGenerator: ImageNameGenerator,
        faceDetectionService: FaceDetectionService,
        imageStorageService: LocalImageStorageService,
        repository: PhotoProjectRepository) {
            self.nameGenerator = nameGenerator
            self.faceDetectionService = faceDetectionService
            self.imageStorageService = imageStorageService
            self.repository = repository
        }
    
    func handleSelectedImageData(_ data: Data, existingProjectsCount: Int) {
        selectedImageData = data
        generatedTitle = nameGenerator.generateName(existingCount: existingProjectsCount)
        processingState = .processing
        
        Task {
            do {
                let hasFace = try await faceDetectionService.detectFace(in: data)
                
                guard let title = generatedTitle else {
                    processingState = .failed(message: "Generated title error")
                    return
                }
                
                _ = try repository.createProject(imageData: data, title: title, hasFace: hasFace)
                processingState = .ready(hasFace: hasFace)
            } catch {
                processingState = .failed(message: error.localizedDescription)
            }
        }
    }
    
    func closeOverlay() {
        selectedImageData = nil
        generatedTitle = nil
        processingState = .idle
    }
    
    func loadImageData(fileName: String) -> Data? {
        try? imageStorageService.loadImage(fileName: fileName)
    }
}
