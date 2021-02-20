//
//  ExtensionTests.swift
//  PortfolioTests
//
//  Created by Paul Jackson on 02/02/2021.
//

import Foundation
import SwiftUI
import XCTest
@testable import Portfolio

@objc class TestIntItem: NSObject, ExpressibleByIntegerLiteral {
    @objc let value: Int
    required init(integerLiteral value: Int) { self.value = value }
    override var description: String { "\(value)"  }
}

class ExtensionTests: XCTestCase {
    func testSequenceDescriptorSorting() {
        let items: [TestIntItem] = [1, 4, 3, 2, 5]
        let actual = items.sorted(by: NSSortDescriptor(keyPath: \TestIntItem.value, ascending: true))
        let expected: [TestIntItem] = [1, 2, 3, 4, 5]

        XCTAssertEqual(actual.description, expected.description)
    }

    func testBundleDecodingAwards() {
        let awards = Bundle.main.decode([Award].self, from: "Awards.json")
        XCTAssertFalse(awards.isEmpty, "Awards.json should decode to a non-empty array")
    }

    func testDecodingString() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode(String.self, from: "DecodableString.json")
        XCTAssertEqual(data, "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "The strings do not match")
    }

    func testDecodableDictionary() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode([String: Int].self, from: "DecodableDictionary.json")
        XCTAssertEqual(data.count, 3, "There should be three items decoded from DecodableDictionary.json")
    }

    func testBindingOnChange() {
        var onChangeFunctionRun = false
        func exampleFunctionToCall() {
            onChangeFunctionRun = true
        }

        var storedValue = ""
        let binding = Binding(get: { storedValue }, set: { storedValue = $0})
        let changedBinding = binding.onChange { exampleFunctionToCall() }

        changedBinding.wrappedValue = "Test"

        XCTAssertTrue(onChangeFunctionRun, "The onChange function was not called")
    }
}
