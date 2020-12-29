//
//  Project-CoreDataHelpers.swift
//  Portfolio
//
//  Created by Paul Jackson on 27/10/2020.
//

import SwiftUI

extension Project {

    /// A `Project` instance that can be used for previews, populated with some sample data.
    ///
    /// No child data is generated, only some top-level properties such as `title`, `detail`, `closed`
    /// and `createdDate`.
    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = "This is an example project"
        project.closed = true
        project.createdDate = Date()

        return project
    }

    /// Array of colour names used as available project colours.
    static let colors = [
        "Pink", "Purple", "Red", "Orange", "Gold",
        "Green", "Teal", "Light Blue", "Dark Blue",
        "Midnight", "Dark Gray", "Gray"
    ]

    /// Title of the project as a String. Defaults to "New Project" (localised) if the model value is `nil`.
    var projectTitle: String {
        title ?? NSLocalizedString("New Project", comment: "Create a new project")
    }

    /// Detail information for the project as a String. Defaults to an empty string if the model value is `nil`.
    var projectDetail: String {
        detail ?? ""
    }

    /// Colour value for the project as a String. Defaults to "Light Blue" if the model object is `nil`.
    var projectColor: String {
        color ?? "Light Blue"
    }

    /// Array of `Item`'s for the project. This property is guaranteed to return a list even if there are no
    /// items in the project.
    var projectItems: [Item] {
        items?.allObjects as? [Item] ?? []
    }

    /// Array of `Item`'s for the project, order by using the default sort algorithm. This property is
    /// guaranteed to return a list even if there are no items in the project.
    ///
    /// The default sort is first by `completed`, then by `priority` and then finally by `creationDate`.
    var projectItemsDefaultSorted: [Item] {
        projectItems.sorted { first, second in
            if first.completed == false {
                if second.completed == true {
                    return true
                }
            } else if first.completed == true {
                if second.completed == false {
                    return false
                }
            }

            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }

            return first.itemCreationDate < second.itemCreationDate
        }
    }

    /// Array of `Item`'s for the project, ordered by using the optional `NSSortDescriptor`; otherwise
    /// the elements will be ordered by using the default sort order.
    ///
    /// - Parameter descriptor: Optional `NSSortDescriptor` used to order the items.
    /// - Returns: `Item` array with the elements order as requested.
    func projectItems(using descriptor: NSSortDescriptor?) -> [Item] {
        guard let descriptor = descriptor else {
            return projectItemsDefaultSorted
        }
        return projectItems.sorted(by: descriptor)
    }

    /// Percentage completion of the project as a Double, where `0.5` means 50% completion
    /// and `1.0` means 100% completion.
    ///
    /// Completion is calculated by dividing the number of completed items against the total
    /// number of items in the project.
    var projectCompletion: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard !originalItems.isEmpty else { return 0 }

        let completedItems = originalItems.filter(\.completed)
        return Double(completedItems.count) / Double(originalItems.count)
    }

    /// Localisation helper for returning a project status summary in an accessible friendly way,  in an attempt to
    /// keep certain logic out of the view code.
    var label: LocalizedStringKey {
        LocalizedStringKey(
            "\(projectTitle), \(projectItems.count) items, \(projectCompletion * 100, specifier: "%g")% complete.")
    }
}
