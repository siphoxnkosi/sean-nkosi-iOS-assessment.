//
//  CoreDataManager.swift
//  About-You
//
//  Created by Sean Nkosi on 2025/02/11.
//

import UIKit
import CoreData

class CoreDataManager: CoreDataManaging {
    static let shared = CoreDataManager()

    private let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "About_You")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }

    private func fetchEngineerEntity(name: String) -> EngineerEntity? {
        let fetchRequest: NSFetchRequest<EngineerEntity> = EngineerEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch engineer: \(error)")
            return nil
        }
    }

    func saveEngineerImage(name: String, imageData: Data) {
        let backgroundContext = self.backgroundContext
        backgroundContext.perform {
            let engineerEntity = self.fetchEngineerEntity(name: name) ?? EngineerEntity(context: backgroundContext)
            engineerEntity.name = name
            engineerEntity.imageData = imageData
            
            do {
                try backgroundContext.save()
            } catch {
                print("Failed to save image: \(error)")
            }
        }
    }

    func fetchEngineerImage(name: String) -> Data? {
        return fetchEngineerEntity(name: name)?.imageData
    }
}
