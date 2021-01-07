//
//  ProjectsView.swift
//  Portfolio
//
//  Created by Paul Jackson on 23/10/2020.
//

import SwiftUI

/// A view  that presents a collection of projects.
struct ProjectsView: View {
    /// String tags used to identify this view in the `TabView` used by the main `ContentView`.
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    /// Environmental data controller instance for the app.
    @EnvironmentObject var dataController: DataController

    /// Environmental CoreData managed object context  instance for the app.
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var showingSortOrder = false
    @State private var sortDescriptor: NSSortDescriptor?

    private let showClosedProjects: Bool
    private let projects: FetchRequest<Project>

    /// Creates an instance of the view for rendering a list of projects.
    ///
    /// - Parameter showClosedProjects: Boolean value to state whether to show close; otherwise open projects.
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects

        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Project.createdDate, ascending: false)
        ], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }

    /// A view that encapsulates the project list.
    var projectsList: some View {
        List {
            ForEach(projects.wrappedValue) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.projectItems(using: sortDescriptor)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { offsets in
                        delete(offsets, from: project)
                    }

                    if showClosedProjects == false {
                        Button {
                            addItem(to: project)
                        } label: {
                            Label("Add New Item", systemImage: "plus")
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    /// Toolbar content view for presenting the Add Project item.
    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if showClosedProjects == false {
                Button(action: addProject) {
                    // In iOS 14.3 VoiceOver has an issue that reads the label "Add Project" as
                    // "Add" no matter what accessibility label we give this button. As a result,
                    // when VoiceOver is running we use a text view for the button instead,
                    // forcing a correct reading without losing the original layout
                    if UIAccessibility.isVoiceOverRunning {
                        Text("Add project")
                    } else {
                        Label("Add project", systemImage: "plus")
                    }
                }
            }
        }
    }

    /// Toolbar content view for presenting the Sort item.
    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSortOrder.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if projects.wrappedValue.isEmpty {
                    Text("There's nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                    projectsList
                }
            }
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                addProjectToolbarItem
                sortOrderToolbarItem
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort items"), message: nil, buttons: [
                    .default(Text("Optimised")) {
                        sortDescriptor = nil
                    },
                    .default(Text("Creation Date")) {
                        sortDescriptor = NSSortDescriptor(
                            keyPath: \Item.creationDate,
                            ascending: true)
                    },
                    .default(Text("Title")) {
                        sortDescriptor = NSSortDescriptor(
                            keyPath: \Item.title,
                            ascending: true)
                    }
                ])
            }

            SelectSomethingView()
        }
    }

    /// Creates a new `Project` instance with default values, and commits to the backing store, with animation.
    func addProject() {
        withAnimation {
            let project = Project(context: managedObjectContext)
            project.closed = false
            project.createdDate = Date()
            dataController.save()
        }
    }

    /// Creates a new `item` instance with default values, with a parent `Project`, commits to the backing
    /// store, with animation.
    ///
    /// - Parameter project: Parent `Project` instance to associate `Item` with.
    func addItem(to project: Project) {
        withAnimation {
            let item = Item(context: managedObjectContext)
            item.project = project
            item.creationDate = Date()
            dataController.save()
        }
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
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
