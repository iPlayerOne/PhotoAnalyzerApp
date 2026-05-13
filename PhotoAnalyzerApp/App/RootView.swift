import SwiftUI
import SwiftData

struct RootView: View {
    private let dependencies: AppDependency
    @State private var projectsViewModel: ProjectsViewModel
    
    init(dependencies: AppDependency) {
        self.dependencies = dependencies
        
        _projectsViewModel = State(
            initialValue: ProjectsViewModel(
                nameGenerator: dependencies.imageNameGenerator,
                faceDetectionService: dependencies.faceDetectionService,
                imageStorageService: dependencies.imageStorageService,
                repository: dependencies.makePhotoProjectRepository()
            ))
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ProjectsView(viewModel: projectsViewModel)
            }
            .blur(radius: projectsViewModel.isOverlayPresented ? 4 : 0)
            
            if let imageData = projectsViewModel.selectedImageData, let title = projectsViewModel.generatedTitle {
                ProcessingPhotoOverlayView(
                    imageData: imageData,
                    title: title,
                    processingState: projectsViewModel.processingState,
                    onClose: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            projectsViewModel.closeOverlay()
                        }
                    }
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    let schema = Schema([PhotoProjectEntity.self])
    let configuration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: true
    )

    let container = try! ModelContainer(
        for: schema,
        configurations: [configuration]
    )

    return RootView(dependencies: AppDependency(modelContainer: container))
    .modelContainer(container)

}
