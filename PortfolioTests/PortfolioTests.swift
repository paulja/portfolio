//
//  PortfolioTests.swift
//  PortfolioTests
//
//  Created by Paul Jackson on 14/01/2021.
//

import CoreData
import XCTest
@testable import Portfolio

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
