//
//  PortfolioApp.swift
//  Portfolio
//
//  Created by Paul Jackson on 23/10/2020.
//

import SwiftUI

@main
struct PortfolioApp: App {
    @StateObject var dataController: DataController

    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .onReceive(
                    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                    perform: save(_:))
        }
    }

    func save(_ notification: Notification) {
        dataController.save()
    }
}
