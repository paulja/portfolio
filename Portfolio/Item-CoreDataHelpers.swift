//
//  Item-CoreDataHelpers.swift
//  Portfolio
//
//  Created by Paul Jackson on 27/10/2020.
//

import Foundation

extension Item {
    var itemTitle: String {
        return title ?? NSLocalizedString("New Item", comment: "Create a new item")
    }

    var itemDetail: String {
        return detail ?? ""
    }

    var itemCreationDate: Date {
        creationDate ?? Date()
    }

    static var example: Item {
        let contoller = DataController(inMemory: true)
        let viewContext = contoller.container.viewContext

        let item = Item(context: viewContext)
        item.title = "Example Item"
        item.detail = "This is an example item"
        item.priority = 3
        item.creationDate = Date()

        return item
    }
}
