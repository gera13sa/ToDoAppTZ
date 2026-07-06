import SwiftUI

enum MainListModule {
    static func build(
        navigationPath: Binding<NavigationPath>,
        repository: TaskRepositoryProtocol = TaskRepository()
    ) -> MainListView {
        let router = MainListRouter()
        router.navigationPath = navigationPath

        let interactor = MainListInteractor(repository: repository)
        let presenter = MainListPresenter(interactor: interactor, router: router)

        return MainListView(
            navigationPath: navigationPath,
            presenter: presenter,
            repository: repository
        )
    }
}
