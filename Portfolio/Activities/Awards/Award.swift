//
//  Award.swift
//  Portfolio
//
//  Created by Paul Jackson on 13/11/2020.
//

import Foundation

/// Models a single award instance and provides access to the award bundle data.
struct Award: Decodable, Identifiable {
    var id: String { name }
    let name: String
    let description: String
    let color: String
    let criterion: String
    let value: Int
    let image: String

    /// Array of `Award` instances modelling the data in the "Awards.json" bundled file.
    static let allAwards = Bundle.main.decode([Award].self, from: "Awards.json")

    /// An `Award` instance that can be used for previews, populated with some sample data.
    static let example = allAwards[0]
}
