import Foundation

struct TaskItem: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var description: String
    var date: Date
    var completed: Bool

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        date: Date = Date(),
        completed: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.completed = completed
    }

    static func fromRemote(_ remote: RemoteToDoItem, index: Int) -> TaskItem {
        TaskItem(
            title: remote.todo,
            description: sampleDescriptions[index % sampleDescriptions.count],
            date: Calendar.current.date(byAdding: .day, value: -index, to: Date()) ?? Date(),
            completed: remote.completed
        )
    }

    var shareText: String {
        [title, description, date.formattedTaskDate].joined(separator: "\n")
    }

    private static let sampleDescriptions = [
        "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
        "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!",
        "Выделить время для чтения. Выбрать интересную книгу и читать перед сном.",
        "Позвонить родным и узнать, как у них дела. Запланировать встречу на выходных.",
        "Разобрать рабочий стол и навести порядок в документах.",
        "Подготовить презентацию к совещанию и проверить все слайды.",
        "Записаться на приём к врачу и не забыть взять результаты анализов."
    ]
}

enum TaskNavigation: Hashable {
    case detail(UUID)
    case create
}

extension Date {
    var formattedTaskDate: String {
        formatted(.dateTime.day(.twoDigits).month(.twoDigits).year(.twoDigits))
    }
}

func tasksCountText(_ count: Int) -> String {
    let rem10 = count % 10
    let rem100 = count % 100

    if rem100 >= 11 && rem100 <= 14 {
        return "\(count) Задач"
    }

    switch rem10 {
    case 1:
        return "\(count) Задача"
    case 2, 3, 4:
        return "\(count) Задачи"
    default:
        return "\(count) Задач"
    }
}
