//
//  Color-Additions.swift
//  Portfolio
//
//  Created by Paul Jackson on 24/11/2020.
//

import SwiftUI

extension Color {
    /// When Apple introduced SwiftUI at WWDC19, they also introduced dark mode for UIKit that allowed us to use
    /// semantic colours for the first time. Sadly, for whatever reason Apple only provided a subset of semantic colours
    /// inside SwiftUI, which means we don’t get background colours (and more).
    ///
    /// We could define these colours in an asset catalog by hand, but where possible it’s preferable to use the
    /// built-in system colours. Not only does that ensure our colours behave correctly right now, but it also ensures
    /// our code updates correctly as Apple makes changes in the future.

    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
}
