import SwiftUI
import SwiftData

struct RootView: View {
    private let dependencies: AppDependencies
    @State private var projectsViewModel: ProjectsViewModel
    @State private var shareItem: ShareItem?
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        
        _projectsViewModel = State(
            initialValue: ProjectsViewModel(
                nameGenerator: dependencies.imageNameGenerator,
                faceDetectionService: dependencies.faceDetectionService,
                imageStorageService: dependencies.imageStorageService,
                repository: dependencies.makePhotoProjectRepository()
            )
        )
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
                    },
                    onExport: {
                        shareItem = projectsViewModel.makeShareItem()
                    }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.96)))
                .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: projectsViewModel.isOverlayPresented)
        .preferredColorScheme(.dark)
        .sheet(item: $shareItem) { item in
            ShareSheet(items: [item.url])
        }
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

    return RootView(dependencies: AppDependencies(modelContainer: container))
        .modelContainer(container)
}
