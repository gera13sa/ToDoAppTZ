import Foundation

protocol TodoServiceProtocol: Sendable {
    func fetchTodos() async throws -> [RemoteToDoItem]
}

final class TodoService: TodoServiceProtocol {
    func fetchTodos() async throws -> [RemoteToDoItem] {
        guard let url = URL(string: "https://dummyjson.com/todos?limit=20") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(TodosResponse.self, from: data).todos
    }
}

final class LocalTodoService: TodoServiceProtocol {
    func fetchTodos() async throws -> [RemoteToDoItem] {
        guard let url = Bundle.main.url(forResource: "todos", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(TodosResponse.self, from: data).todos
    }
}
