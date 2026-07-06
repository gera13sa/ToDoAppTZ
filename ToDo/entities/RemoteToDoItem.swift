import Foundation

struct RemoteToDoItem: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

struct TodosResponse: Decodable {
    let todos: [RemoteToDoItem]
}
