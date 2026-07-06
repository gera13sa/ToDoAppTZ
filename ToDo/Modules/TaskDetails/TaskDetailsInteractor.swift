import Foundation

protocol TaskDetailsInteractorInput: AnyObject {
    func loadTask(id: UUID) throws -> TaskItem?
    func saveTask(_ task: TaskItem) throws
}

final class TaskDetailsInteractor: TaskDetailsInteractorInput {
    private let repository: TaskRepositoryProtocol

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
    }

    func loadTask(id: UUID) throws -> TaskItem? {
        try repository.task(with: id)
    }

    func saveTask(_ task: TaskItem) throws {
        try repository.saveTask(task)
    }
}
