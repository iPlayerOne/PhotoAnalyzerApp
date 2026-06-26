import SwiftUI
import SwiftData

@main
struct PhotoAnalyzerApp: App {
    private let sharedModelContainer: ModelContainer
    private let dependencies: AppDependencies
    
    init() {
        let schema = Schema([PhotoProjectEntity.self])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            let container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            
            self.sharedModelContainer = container
            self.dependencies = AppDependencies(modelContainer: container)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(dependencies: dependencies)
        }
        .modelContainer(sharedModelContainer)
    }
}
