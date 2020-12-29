//
//  Binding-OnChange.swift
//  Portfolio
//
//  Created by Paul Jackson on 28/10/2020.
//

import SwiftUI

extension Binding {

    /// Calls a handler closure when a change in the wrapped value occurs.
    ///
    /// It is often useful to take action when a binding's wrapped value changes. This
    /// function provides an option to give a closure to enable upstream listeners the
    /// ability to called when changes occur in the wrapped value.
    ///
    /// - Parameter handler: closure to call on changes to the wrapped value.
    /// - Returns: A new `Binding` instance.
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
