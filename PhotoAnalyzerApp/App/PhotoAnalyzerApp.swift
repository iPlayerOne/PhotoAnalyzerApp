import SwiftUI
import SwiftData

@main
struct PhotoAnalyzerApp: App {
    private let sharedModelContainer: ModelContainer
    private let dependencies: AppDependency
    
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
            self.dependencies = AppDependency(modelContainer: container)
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
