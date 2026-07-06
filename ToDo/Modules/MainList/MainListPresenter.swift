import Foundation
import Observation

@Observable
final class MainListPresenter {
    var items: [TaskItem] = []
    var searchQuery = ""
    var isLoading = false
    var errorMessage: String?

    var filteredItems: [TaskItem] {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return items }

        return items.filter { task in
            task.title.localizedCaseInsensitiveContains(query)
                || task.description.localizedCaseInsensitiveContains(query)
        }
    }

    var countText: String {
        tasksCountText(items.count)
    }

    private let interactor: MainListInteractorInput
    private let router: MainListRouterInput

    init(interactor: MainListInteractorInput, router: MainListRouterInput) {
        self.interactor = interactor
        self.router = router
    }

    func onAppear() {
        Task { await load() }
    }

    func didSelect(_ task: TaskItem) {
        router.showDetails(for: task.id)
    }

    func didTapCreate() {
        router.showCreateTask()
    }

    func didToggleCompletion(for task: TaskItem) {
        Task {
            do {
                items = try await interactor.toggleCompletion(for: task.id)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func didDelete(_ task: TaskItem) {
        Task {
            do {
                items = try await interactor.deleteTask(id: task.id)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            items = try await interactor.loadTasks()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
