//
//  Project-CoreDataHelpers.swift
//  Portfolio
//
//  Created by Paul Jackson on 27/10/2020.
//

import Foundation

extension Project {
    static let colors = [
        "Pink", "Purple", "Red", "Orange", "Gold",
        "Green", "Teal", "Light Blue", "Dark Blue",
        "Midnight", "Dark Gray", "Gray"
    ]

    var projectTitle: String {
        title ?? "New Project"
    }
    
    var projectDetail: String {
        detail ?? ""
    }
    
    var projectColor: String {
        color ?? "Light Blue"
    }

    var projectItems: [Item] {
        let itemsArray = items?.allObjects as? [Item] ?? []
        return itemsArray.sorted { first, second in
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
