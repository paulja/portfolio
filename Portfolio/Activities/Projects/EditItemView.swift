//
//  EditItemView.swift
//  Portfolio
//
//  Created by Paul Jackson on 28/10/2020.
//

import SwiftUI

/// A view that enables management of an `Item`.
struct EditItemView: View {
    private let item: Item

    /// An environmental data controller object instance for CoreData interaction.
    @EnvironmentObject var dataController: DataController

    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool

    /// Constructs a view by using an `Item` instance.
    ///
    /// - Parameter item: `Item` instance modelling the item to be edited.
    init(item: Item) {
        self.item = item

        _title = State(wrappedValue: item.itemTitle)
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
        _completed = State(wrappedValue: item.completed)
    }

    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Title", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            }

            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority.onChange(update)) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section {
                Toggle("Mark Completed", isOn: $completed.onChange(update))
            }
        }
        .navigationTitle("Edit Item")
        .onDisappear(perform: dataController.save)
    }

    /// Updates the `Item` instance with the State object values.
    ///
    /// Before updating the model object this function signals that the parent `Project` instance is about
    /// to change. The purpose of doing this is to ensure that any upstream views refresh themselves with
    /// the new data.
    func update() {
        item.project?.objectWillChange.send()

        item.title = title
        item.detail = detail
        item.priority = Int16(priority)
        item.completed = completed
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: Item.example)
            .environmentObject(DataController.preview)
    }
}
