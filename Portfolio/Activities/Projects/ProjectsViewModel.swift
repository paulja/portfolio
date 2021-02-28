//
//  ProjectsViewModel.swift
//  Portfolio
//
//  Created by Paul Jackson on 28/02/2021.
//

import Foundation
import CoreData
import SwiftUI

extension ProjectsView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let dataController: DataController

        var sortDescriptor: NSSortDescriptor?
        let showClosedProjects: Bool

        private let projectsController: NSFetchedResultsController<Project>
        @Published var projects = [Project]()

        /// Creates an instance of the view for rendering a list of projects.
        ///
        /// - Parameter showClosedProjects: Boolean value to state whether to show close; otherwise open projects.
        init(dataController: DataController, showClosedProjects: Bool) {
            self.dataController = dataController
            self.showClosedProjects = showClosedProjects

            let request: NSFetchRequest<Project> = Project.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.createdDate, ascending: false)]
            request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)

            projectsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            super.init()
            projectsController.delegate = self

            do {
                try projectsController.performFetch()
                projects = projectsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch projects")
            }
        }

        /// Creates a new `Project` instance with default values, and commits to the backing store, with animation.
        func addProject() {
            let project = Project(context: dataController.container.viewContext)
            project.closed = false
            project.createdDate = Date()
            dataController.save()
        }

        /// Creates a new `item` instance with default values, with a parent `Project`, commits to the backing
        /// store, with animation.
        ///
        /// - Parameter project: Parent `Project` instance to associate `Item` with.
        func addItem(to project: Project) {
            let item = Item(context: dataController.container.viewContext)
            item.project = project
            item.creationDate = Date()
            dataController.save()
        }

        /// Removes the `Item`'s at the offsets from a `Project`.
        ///
        /// After all items have been removed from the offset locations, the result is committed to the backing store.
        ///
        /// - Parameters:
        ///   - offsets: indexes  into the list of project items.
        ///   - project: parent project to remove the items from.
        func delete(_ offsets: IndexSet, from project: Project) {
            let allItems = project.projectItems(using: sortDescriptor)
            for offset in offsets {
                let item = allItems[offset]
                dataController.delete(item)
            }
            dataController.save()
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            }
        }
    }
}
