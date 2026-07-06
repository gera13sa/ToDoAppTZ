import Foundation

protocol MainListInteractorInput: AnyObject {
    func loadTasks() async throws -> [TaskItem]
    func toggleCompletion(for id: UUID) async throws -> [TaskItem]
    func deleteTask(id: UUID) async throws -> [TaskItem]
}

final class MainListInteractor: MainListInteractorInput {
    private let repository: TaskRepositoryProtocol

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
    }

    func loadTasks() async throws -> [TaskItem] {
        try await repository.loadTasks()
    }

    func toggleCompletion(for id: UUID) async throws -> [TaskItem] {
        guard var task = try repository.task(with: id) else {
            throw TaskRepositoryError.taskNotFound
        }
        task.completed.toggle()
        try repository.saveTask(task)
        return try await repository.loadTasks()
    }

    func deleteTask(id: UUID) async throws -> [TaskItem] {
        try repository.deleteTask(id: id)
        return try await repository.loadTasks()
    }
}

enum TaskRepositoryError: LocalizedError {
    case taskNotFound

    var errorDescription: String? {
        switch self {
        case .taskNotFound:
            return "Задача не найдена"
        }
    }
}
