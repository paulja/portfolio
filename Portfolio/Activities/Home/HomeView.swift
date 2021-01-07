//
//  HomeView.swift
//  Portfolio
//
//  Created by Paul Jackson on 23/10/2020.
//

import SwiftUI
import CoreData

/// A view that represents the Home tab.
struct HomeView: View {
    /// String tag used to identify this view in the `TabView` used by the main `ContentView`.
    static let tag: String? = "Home"

    /// Environmental data controller instance for the app.
    @EnvironmentObject var dataController: DataController

    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
        predicate: NSPredicate(format: "closed = false"))
    private var projects: FetchedResults<Project>

    private let items: FetchRequest<Item>

    private var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    /// Constructs a view and the request required to get the projects to interact with.
    init() {
        // Construct a fetch request to show the 10 highest-priority,
        // incomplete items from all open projects.
        let completedPredicate = NSPredicate(format: "completed = false")
        let openPredicate = NSPredicate(format: "project.closed = false")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [completedPredicate, openPredicate])
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.fetchLimit = 10
        request.predicate = compoundPredicate
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Item.priority, ascending: false)
        ]
        items = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(projects, content: ProjectSummaryView.init)
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading) {
                        ItemListView(title: "Up next", items: items.wrappedValue.prefix(3))
                        ItemListView(title: "More to explore", items: items.wrappedValue.dropFirst(3))
                    }
                    .padding([.horizontal, .bottom])
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
            .navigationBarItems(
                trailing: Button(action: {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }, label: {
                    Image(systemName: "rectangle.stack.badge.plus")
                })
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
