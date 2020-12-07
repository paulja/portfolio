//
//  Project-CoreDataHelpers.swift
//  Portfolio
//
//  Created by Paul Jackson on 27/10/2020.
//

import SwiftUI

extension Project {
    static let colors = [
        "Pink", "Purple", "Red", "Orange", "Gold",
        "Green", "Teal", "Light Blue", "Dark Blue",
        "Midnight", "Dark Gray", "Gray"
    ]

    var projectTitle: String {
        title ?? NSLocalizedString("New Project", comment: "Create a new project")
    }
    
    var projectDetail: String {
        detail ?? ""
    }
    
    var projectColor: String {
        color ?? "Light Blue"
    }

    var projectItems: [Item] {
        items?.allObjects as? [Item] ?? []
    }

    func projectItems(using descriptor: NSSortDescriptor?) -> [Item] {
        guard let descriptor = descriptor else {
            return projectItemsDefaultSorted
        }
        return projectItems.sorted(by: descriptor)
    }

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
            } else if first.priority < second.priority  {
                return false
            }
            
            return first.itemCreationDate < second.itemCreationDate
        }
    }
    
    var projectCompletion: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard !originalItems.isEmpty else { return 0 }
    
        let completedItems = originalItems.filter(\.completed)
        return Double(completedItems.count) / Double(originalItems.count)
    }

    var label: LocalizedStringKey {
        LocalizedStringKey(
            "\(projectTitle), \(projectItems.count) items, \(projectCompletion * 100, specifier: "%g")% complete.")
    }

    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let project = Project(context: viewContext)
        project.title = "Exmaple Project"
        project.detail = "This is an example project"
        project.closed = true
        project.createdDate = Date()
        
        return project
    }
}
