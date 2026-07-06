import SwiftUI

protocol MainListRouterInput: AnyObject {
    func showDetails(for id: UUID)
    func showCreateTask()
}

final class MainListRouter: MainListRouterInput {
    var navigationPath: Binding<NavigationPath>?

    func showDetails(for id: UUID) {
        navigationPath?.wrappedValue.append(TaskNavigation.detail(id))
    }

    func showCreateTask() {
        navigationPath?.wrappedValue.append(TaskNavigation.create)
    }
}
