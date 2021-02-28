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

    @StateObject var viewModel: ViewModel
    @State private var showingSortOrder = false

    init(dataController: DataController, showClosedProjects: Bool) {
        let viewModel = ViewModel(
            dataController: dataController,
            showClosedProjects: showClosedProjects
        )
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    /// A view that encapsulates the project list.
    var projectsList: some View {
        List {
            ForEach(viewModel.projects) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.projectItems(using: viewModel.sortDescriptor)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { offsets in
                        viewModel.delete(offsets, from: project)
                    }

                    if viewModel.showClosedProjects == false {
                        Button {
                            withAnimation {
                                viewModel.addItem(to: project)
                            }
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
            if viewModel.showClosedProjects == false {
                Button {
                    withAnimation {
                        viewModel.addProject()
                    }
                } label: {
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
                if viewModel.projects.isEmpty {
                    Text("There's nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                    projectsList
                }
            }
            .navigationTitle(viewModel.showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                addProjectToolbarItem
                sortOrderToolbarItem
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort items"), message: nil, buttons: [
                    .default(Text("Optimised")) {
                        viewModel.sortDescriptor = nil
                    },
                    .default(Text("Creation Date")) {
                        viewModel.sortDescriptor = NSSortDescriptor(
                            keyPath: \Item.creationDate,
                            ascending: true)
                    },
                    .default(Text("Title")) {
                        viewModel.sortDescriptor = NSSortDescriptor(
                            keyPath: \Item.title,
                            ascending: true)
                    }
                ])
            }

            SelectSomethingView()
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ProjectsView(
            dataController: DataController.init(inMemory: true),
            showClosedProjects: false)
    }
}
