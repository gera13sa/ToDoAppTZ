import Foundation

protocol TaskRepositoryProtocol: AnyObject {
    func loadTasks() async throws -> [TaskItem]
    func task(with id: UUID) throws -> TaskItem?
    func saveTask(_ task: TaskItem) throws
    func deleteTask(id: UUID) throws
}

final class TaskRepository: TaskRepositoryProtocol {
    private let apiService: TodoServiceProtocol
    private let fileURL: URL

    init(apiService: TodoServiceProtocol = TodoService()) {
        self.apiService = apiService
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = documents.appendingPathComponent("tasks.json")
    }

    func loadTasks() async throws -> [TaskItem] {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return try loadFromDisk()
        }

        let remoteItems = try await apiService.fetchTodos()
        let tasks = remoteItems.enumerated().map { index, item in
            TaskItem.fromRemote(item, index: index)
        }
        try saveToDisk(tasks)
        return tasks
    }

    func task(with id: UUID) throws -> TaskItem? {
        try loadFromDisk().first { $0.id == id }
    }

    func saveTask(_ task: TaskItem) throws {
        var tasks = try loadFromDisk()
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        } else {
            tasks.insert(task, at: 0)
        }
        try saveToDisk(tasks)
    }

    func deleteTask(id: UUID) throws {
        var tasks = try loadFromDisk()
        tasks.removeAll { $0.id == id }
        try saveToDisk(tasks)
    }

    private func loadFromDisk() throws -> [TaskItem] {
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([TaskItem].self, from: data)
    }

    private func saveToDisk(_ tasks: [TaskItem]) throws {
        let data = try JSONEncoder().encode(tasks)
        try data.write(to: fileURL, options: .atomic)
    }
}

final class InMemoryTaskRepository: TaskRepositoryProtocol {
    private var tasks: [TaskItem]

    init(tasks: [TaskItem] = TaskItem.previewItems) {
        self.tasks = tasks
    }

    func loadTasks() async throws -> [TaskItem] {
        tasks
    }

    func task(with id: UUID) throws -> TaskItem? {
        tasks.first { $0.id == id }
    }

    func saveTask(_ task: TaskItem) throws {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        } else {
            tasks.insert(task, at: 0)
        }
    }

    func deleteTask(id: UUID) throws {
        tasks.removeAll { $0.id == id }
    }
}

extension TaskItem {
    static let previewItems: [TaskItem] = [
        TaskItem(
            title: "Поесть",
            description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 9)) ?? Date(),
            completed: true
        ),
        TaskItem(
            title: "Сделать домашнее задание",
            description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 9)) ?? Date(),
            completed: false
        ),
        TaskItem(
            title: "Поиграть в Dota",
            description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 9)) ?? Date(),
            completed: false
        ),
        TaskItem(
            title: "Заняться спортом",
            description: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!",
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 2)) ?? Date(),
            completed: false
        )
    ]
}
