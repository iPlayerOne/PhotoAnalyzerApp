import SwiftUI
import SwiftData
import PhotosUI

struct ProjectsView: View {
    let viewModel: ProjectsViewModel
    
    @Query(sort: \PhotoProjectEntity.createdAt, order: .reverse) private var projects: [PhotoProjectEntity]
    
    @State private var searchText: String = ""
    @State private var selectedPickerItem: PhotosPickerItem?
    @State private var isPhotoPickerPresented: Bool = false
    
    private var filteredProjects: [PhotoProjectEntity] {
        guard !searchText.isEmpty else { return projects }
        return projects.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var leftColumn: [PhotoProjectEntity] {
        filteredProjects.enumerated()
            .filter{ index, _ in index.isMultiple(of: 2) }
            .map { _, project in project }
    }
    
    private var rightColumn: [PhotoProjectEntity] {
        filteredProjects.enumerated()
            .filter{ index, _ in !index.isMultiple(of: 2) }
            .map { _, project in project }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                
                if projects.isEmpty {
                    EmptyProjectsView {
                        isPhotoPickerPresented = true
                    }
                } else {
                    projectsList
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 24)
            
            
            
            
        }
        .navigationTitle(AppStrings.Projects.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                addButton
            }
            
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: AppStrings.Projects.searchPlaceholder
        )
        .photosPicker(
            isPresented: $isPhotoPickerPresented,
            selection: $selectedPickerItem,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: selectedPickerItem) { _, newItem in
            guard let newItem else { return }
            
            Task {
                do {
                    if let data = try await newItem.loadTransferable(type: Data.self) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.handleSelectedImageData(data, existingProjectsCount: projects.count)
                        }
                    }
                } catch {
                    viewModel.processingState = .failed(message: error.localizedDescription)
                }
                selectedPickerItem = nil
                isPhotoPickerPresented = false
                
            }
        }
    }
    
}

extension ProjectsView {
    @ViewBuilder
    private func projectCard(for project: PhotoProjectEntity) -> some View {
        ProjectCardView(
            imageID: project.fileName,
            loadImageData: {
                viewModel.loadImageData(fileName: project.fileName)
            },
            title: project.title,
            hasFace: project.hasFace,
            orientation: project.orientation
        ) {
            withAnimation(.easeInOut(duration: 0.25)) {
                viewModel.openProject(project)
            }
        }
    }
    private var addButton: some View {
        Button {
            isPhotoPickerPresented = true
        } label: {
            Image(systemName: "photo.badge.plus")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color("AccentMint"))
        }
        
    }
    
    
    private var projectsList: some View {
        GeometryReader { proxy in
            let spacing: CGFloat = 12
            let availableWidth = max(proxy.size.width - spacing, 0)
            let columnWidth = availableWidth / 2
            
            ScrollView(showsIndicators: false) {
                HStack(alignment: .top, spacing: spacing) {
                    LazyVStack(spacing: spacing) {
                        ForEach(leftColumn, id: \.id) { project in
                            projectCard(for: project)
                                .frame(width: columnWidth)
                        }
                    }
                    .frame(width: columnWidth)
                    
                    LazyVStack(spacing: spacing) {
                        ForEach(rightColumn, id: \.id) { project in
                            projectCard(for: project)
                                .frame(width: columnWidth)
                        }
                    }
                    .frame(width: columnWidth)
                }
                .padding(.top, 8)
            }
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
    
    let dependencies = AppDependency(modelContainer: container)
    
    let viewModel = ProjectsViewModel(
        nameGenerator: dependencies.imageNameGenerator,
        faceDetectionService: dependencies.faceDetectionService,
        imageStorageService: dependencies.imageStorageService,
        repository: dependencies.makePhotoProjectRepository()
    )
    
    return NavigationStack {
        ProjectsView(viewModel: viewModel)
    }
    .modelContainer(container)
    .preferredColorScheme(.dark)
}
