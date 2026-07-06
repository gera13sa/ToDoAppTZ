import SwiftUI

@main
struct ToDoApp: App {
    @State private var navigationPath = NavigationPath()
    private let repository = TaskRepository()

    var body: some Scene {
        WindowGroup {
            MainListModule.build(navigationPath: $navigationPath, repository: repository)
                .preferredColorScheme(.dark)
        }
    }
}
