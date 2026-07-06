import Foundation
import Observation

@Observable
final class TaskDetailsPresenter {
    var title: String
    var description: String
    var date: Date

    private let taskId: UUID
    private let isNew: Bool
    private var completed: Bool
    private let interactor: TaskDetailsInteractorInput

    init(taskId: UUID, isNew: Bool, interactor: TaskDetailsInteractorInput) {
        self.taskId = taskId
        self.isNew = isNew
        self.interactor = interactor

        if isNew {
            title = ""
            description = ""
            date = Date()
            completed = false
        } else if let task = try? interactor.loadTask(id: taskId) {
            title = task.title
            description = task.description
            date = task.date
            completed = task.completed
        } else {
            title = ""
            description = ""
            date = Date()
            completed = false
        }
    }

    func save() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)

        if isNew && trimmedTitle.isEmpty && trimmedDescription.isEmpty {
            return
        }

        let task = TaskItem(
            id: taskId,
            title: trimmedTitle.isEmpty ? "Новая задача" : trimmedTitle,
            description: trimmedDescription,
            date: date,
            completed: completed
        )

        try? interactor.saveTask(task)
    }
}
