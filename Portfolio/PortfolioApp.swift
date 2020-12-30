//
//  PortfolioApp.swift
//  Portfolio
//
//  Created by Paul Jackson on 23/10/2020.
//

import SwiftUI

@main
/// App definition for the Portfolio App.
struct PortfolioApp: App {
    /// Environmental data controller instance for the app.
    @StateObject var dataController: DataController

    /// Constructs the app including a persistent store instance of the data controller as a `State` object.
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)

                // Automatically save when we detect that we are no longer
                // for foreground app. Use this rather than scene phase so we
                // can port to macOS, where scene phase won't detect our app
                // losing focus as of macOS 11.1
                .onReceive(
                    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                    perform: save(_:))
        }
    }

    /// Attempts to commit CoreData changes by using the environmental data controller.
    /// 
    /// - Parameter notification: `Notification` instance that triggered the function. Argument unused.
    func save(_ notification: Notification) {
        dataController.save()
    }
}
