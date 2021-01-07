//
//  SelectSomethingView.swift
//  Portfolio
//
//  Created by Paul Jackson on 10/11/2020.
//

import SwiftUI

/// A view to present when there are no projects yet in the backing store.
struct SelectSomethingView: View {
    var body: some View {
        Text("Please select something from the menu to begin.")
            .italic()
            .foregroundColor(.secondary)
    }
}

struct SelectSomethingView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSomethingView()
    }
}
