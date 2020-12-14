//
//  HomeView.swift
//  Portfolio
//
//  Created by Paul Jackson on 23/10/2020.
//

import SwiftUI
import CoreData

struct HomeView: View {
    static let tag: String? = "Home"

    @EnvironmentObject var dataController: DataController

    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
        predicate: NSPredicate(format: "closed = false"))
    var projects: FetchedResults<Project>

    let items: FetchRequest<Item>

    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    init() {

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
