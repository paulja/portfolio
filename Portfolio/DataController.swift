//
//  DataController.swift
//  Portfolio
//
//  Created by Paul Jackson on 23/10/2020.
//

import CoreData
import SwiftUI

/// An environment singleton responsible for managing the CoreData stack, which includes saving,
/// counting fetch requests, tracking awards, and deals with sample data.
class DataController: ObservableObject {
    /// A CloudKit container used to store all app data.
    let container: NSPersistentCloudKitContainer

    /// Initialises a data controller, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs).
    ///
    /// Defaults to permanent storage.
    ///
    /// - Parameter inMemory: Whether to store this data in temporary storage or not.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

        // For testing and previewing purposes, we create a temporary, in-memory database
        // by writing to /dev/null so our data is destroyed after the app finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }

    /// Loads the Main CoreData object model from the bundle resource.
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()

    /// Returns a new data controller for SwiftUI Previews by using an in memory (temporary) store.
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController
    }()

    /// Creates example projects and items to make manual testing easier.
    ///
    /// - Throws: an NSError send from calling `save()` on the `NSManagedObjectContext`.
    func createSampleData() throws {
        let viewContext = container.viewContext

        for projectIndex in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(projectIndex)"
            project.items = []
            project.createdDate = Date()
            project.closed = Bool.random()

            for itemIndex in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(itemIndex)"
                item.creationDate = Date()
                item.completed = false
                item.project = project
                item.priority = Int16.random(in: 1...3)

                item.completed = Bool.random()
            }
        }

        try viewContext.save()
    }

    /// Saves our CoreData context iff there are changes. This silently ignores any errors caused
    /// by saving. This should be fine because all our attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    /// Specifies an object to remove from the store when changes are committed against the active context.
    ///
    /// - Parameter object: `NSManagedObject` to remove from the store.
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    /// Attempts to remove all objects from store when changes are committed against the active context.
    ///
    /// The function attempts to find all relevant data by using a couple of fetch requests, first for `Item`'s and then
    /// for `Project`'s.
    ///
    /// When originally developed the relationship between `Item` and `Project` was to null,
    /// this has since been modified to use a cascade delete; therefore, it maybe possible to refactor to a single
    /// fetch request to remove just projects.
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }

    /// Generic function with returns an `Int` value that represents the number of items returned from the passed in
    /// fetch request.
    ///
    /// If the request does not find any items the function will return `0`. This function silently ignores any errors
    /// caused when executing the fetch request, preferring to return `0` for nil returns, as opposed to throwing.
    ///
    /// - Parameter fetchRequest: Generic fetch request to run to get the count result from.
    /// - Returns: The number of items fetched in the request, or `0` if there were no results found.
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    /// Returns `true` if criterion has been met for the `Award`; otherwise returns `false`.
    ///
    /// - Parameter award: The `Award` to check against.
    /// - Returns: `true` if the criterion has been met; otherwise, `false`.
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "items":
            // returns true if the user added a certain number of items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "complete":
            // returns true if the user completed a certain number of items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        default:
            // an unknown award criterion; this should never be allowed
            // fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }
    }
}
