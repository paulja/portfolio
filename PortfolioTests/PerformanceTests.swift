//
//  PerformanceTests.swift
//  PortfolioTests
//
//  Created by Paul Jackson on 20/02/2021.
//

import XCTest
@testable import Portfolio

class PerformanceTests: BaseTestCase {
    func testAwareCalculationPerformance() throws {
        for _ in 1...100 {
            try dataController.createSampleData()
        }

        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "This checks the awards count is constant. Change this if you add awards")

        measure {
            _ = awards.filter(dataController.hasEarned).count
        }
    }
}
