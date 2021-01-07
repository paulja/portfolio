//
//  ItemRowView.swift
//  Portfolio
//
//  Created by Paul Jackson on 28/10/2020.
//

import SwiftUI

/// A view that models a single item row.
struct ItemRowView: View {
    /// Parent project for the item.
    @ObservedObject var project: Project

    /// Item instance being presented.
    @ObservedObject var item: Item

    /// An image view keyed from the state of the item.
    ///
    /// Renders different images based on whether the item is completed and it's priority.
    var icon: some View {
        if item.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(project.projectColor))
        } else if item.priority == 3 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(project.projectColor))
        } else {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }

    /// A text view keyed from the state of the item.
    var label: Text {
        if item.completed {
            return Text("\(item.itemTitle), completed.")
        } else if item.priority == 3 {
            return Text("\(item.itemTitle), high priority.")
        } else {
            return Text(item.itemTitle)
        }
    }

    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Label {
                Text(item.itemTitle)
            } icon: {
                icon

            }
            .accessibilityLabel(label)
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(project: Project.example, item: Item.example)
    }
}
