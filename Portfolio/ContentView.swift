//
//  ContentView.swift
//  Portfolio
//
//  Created by Paul Jackson on 23/10/2020.
//

import SwiftUI

/// The main content view for the app.
///
/// This root view is a `TabView` that is responsible for owning all the child views that make up the raw
/// user interface. The active tab is remembered between sessions by using scene storage based on
/// the `tag` value for each tab `View`.
struct ContentView: View {
    /// Used to store the selected tab / view between sessions in scene storage.
    @SceneStorage("selectedView") var selectedView: String?

    /// Environmental data controller instance for the app.
    @EnvironmentObject var dataController: DataController

    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            ProjectsView(dataController: dataController, showClosedProjects: false)
                .tag(ProjectsView.openTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Open")
                }

            ProjectsView(dataController: dataController, showClosedProjects: true)
                .tag(ProjectsView.closedTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }

            AwardsView()
                .tag(AwardsView.tag)
                .tabItem {
                    Image(systemName: "rosette")
                    Text("Awards")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
