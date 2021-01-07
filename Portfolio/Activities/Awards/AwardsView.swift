//
//  AwardsView.swift
//  Portfolio
//
//  Created by Paul Jackson on 13/11/2020.
//

import SwiftUI

/// A view for presenting and interacting with `Award`s.
struct AwardsView: View {
    /// String tag used to identify this view in the `TabView` used by the main `ContentView`.
    static let tag: String? = "Awards"

    /// Environmental data controller instance for the app.
    @EnvironmentObject var dataController: DataController

    @State private var selectedAward = Award.example
    @State private var showingAwardDetails = false

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            selectedAward = award
                            showingAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(dataController.hasEarned(award: award) ?
                                    Color(award.color) : Color.secondary.opacity(0.5))
                        }
                        .accessibilityLabel(
                            Text(dataController.hasEarned(award: award) ? "Unlocked: \(award.name)" : "Locked")
                        )
                        .accessibilityHint(Text(award.description))
                    }
                }
            }
            .navigationTitle("Awards")
        }
        .alert(isPresented: $showingAwardDetails) {
            if dataController.hasEarned(award: selectedAward) {
                return Alert(title: Text("Unlocked: \(selectedAward.name)"),
                             message: Text(selectedAward.description),
                             dismissButton: .default(Text("OK")))
            } else {
                return Alert(title: Text("Locked"),
                             message: Text(selectedAward.description),
                             dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
    }
}
