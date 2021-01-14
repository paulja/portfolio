//
//  ProjectHeaderView.swift
//  Portfolio
//
//  Created by Paul Jackson on 30/10/2020.
//

import SwiftUI

/// A header view that presents a section like header for a project.
struct ProjectHeaderView: View {
    /// An observed project object which is the base for the header data.
    @ObservedObject var project: Project

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.projectTitle)
                ProgressView(value: project.projectCompletion)
                    .accentColor(Color(project.projectColor))
            }

            Spacer()

            NavigationLink(destination: EditProjectView(project: project)) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
        }
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: Project.example)
            .padding(40)
    }
}
