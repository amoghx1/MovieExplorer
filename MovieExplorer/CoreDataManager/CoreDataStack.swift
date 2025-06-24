//
//  CoreDataStack.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 22/06/25.
//

import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieExplorer")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("  Unresolved error: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("  Error saving context: \(error)")
            }
        }
    }
}

