//
//  ProjectSummaryView.swift
//  Portfolio
//
//  Created by Paul Jackson on 06/12/2020.
//

import SwiftUI

/// A view that presents a summary view for a `Project`.
struct ProjectSummaryView: View {
    /// An observed project object which is the base for the summary data.
    @ObservedObject var project: Project

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(project.projectItems.count) items")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(project.projectTitle)
                .font(.title2)

            ProgressView(value: project.projectCompletion)
                .accentColor(Color(project.projectColor))
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(project.label)
    }
}

struct ProjectSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSummaryView(project: Project.example)
            .padding(40)
    }
}
