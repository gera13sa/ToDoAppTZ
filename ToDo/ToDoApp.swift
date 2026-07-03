//
//  ToDoApp.swift
//  ToDo
//
//  Created by Александр Герасимов on 03.07.2026.
//

import SwiftUI
import CoreData

@main
struct ToDoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
