//
//  AssetTest.swift
//  PortfolioTests
//
//  Created by Paul Jackson on 14/01/2021.
//

import XCTest
@testable import Portfolio

class AssetTest: XCTestCase {
    func testColorsExist() {
        for colour in Project.colours {
            XCTAssertNotNil(UIColor(named: colour), "Failed to load colour '\(colour)' from asset catalogue")
        }
    }

    func testJSONLoadsCorrectly() {
        XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load awards from JSON")
    }
}
