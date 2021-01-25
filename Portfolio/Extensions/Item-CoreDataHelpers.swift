//
//  Item-CoreDataHelpers.swift
//  Portfolio
//
//  Created by Paul Jackson on 27/10/2020.
//

import Foundation

extension Item {
    /// A `Item` instance that can be used for previews, populated with some sample data.
    ///
    /// No child data is generated, only some top-level properties such as `title`, `detail`, `priority`
    /// and `createdDate`.
    static var example: Item {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let item = Item(context: viewContext)
        item.title = "Example Item"
        item.detail = "This is an example item"
        item.priority = 3
        item.creationDate = Date()

        return item
    }

    /// Title of the item as a String. Defaults to "New Item" (localised) if the model value is `nil`.
    var itemTitle: String {
        return title ?? NSLocalizedString("New Item", comment: "Create a new item")
    }

    /// Detail information for the item as a String. Defaults to an empty string if the model value is `nil`.
    var itemDetail: String {
        return detail ?? ""
    }

    /// Date the item was created. Defaults to the date the request was made if the model value is `nil`.
    var itemCreationDate: Date {
        creationDate ?? Date()
    }
}
