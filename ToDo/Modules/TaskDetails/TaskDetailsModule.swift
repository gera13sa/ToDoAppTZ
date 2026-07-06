import SwiftUI

enum TaskDetailsModule {
    static func build(taskId: UUID, repository: TaskRepositoryProtocol) -> TaskDetailsView {
        let interactor = TaskDetailsInteractor(repository: repository)
        let presenter = TaskDetailsPresenter(taskId: taskId, isNew: false, interactor: interactor)
        return TaskDetailsView(presenter: presenter)
    }

    static func buildNew(repository: TaskRepositoryProtocol) -> TaskDetailsView {
        let interactor = TaskDetailsInteractor(repository: repository)
        let presenter = TaskDetailsPresenter(taskId: UUID(), isNew: true, interactor: interactor)
        return TaskDetailsView(presenter: presenter)
    }
}
