//
//  EditProjectView.swift
//  Portfolio
//
//  Created by Paul Jackson on 30/10/2020.
//

import SwiftUI

/// A view that enables management of a `Project` instance.
struct EditProjectView: View {
    private let project: Project

    /// An environmental data controller object instance for CoreData interaction.
    @EnvironmentObject var dataController: DataController

    /// An environment property used to manage the presentation mode of the view.
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var colour: String
    @State private var showingDeleteConfirm = false

    private let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    /// Constructs a view by using an `Project` instance.
    ///
    /// - Parameter project: `Project` instance modelling the project to be edited.
    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _colour = State(wrappedValue: project.projectColor)
    }

    /// A section view that contains the settings view elements.
    private var settingsSection: some View {
        Section(header: Text("Basic settings")) {
            TextField("Project name", text: $title.onChange(update))
            TextField("Description of this project", text: $detail.onChange(update))
        }
    }

    /// A section view that contains the colour picker view elements.
    private var colourSection: some View {
        Section(header: Text("Custom project color")) {
            LazyVGrid(columns: colorColumns) {
                ForEach(Project.colours, id: \.self, content: colorButton)
            }
            .padding(.vertical)
        }
    }

    /// A section view that contains the footer view with the controls for the view.
    private var footerSection: some View {
        Section(footer: Text("Closing a project moves it from the Open to Closed tab; deleting it removes" +
                                " the project completely.")) {
            Button(project.closed ? "Reopen this project" : "Close this project") {
                project.closed.toggle()
                update()
            }

            Button("Delete this project") {
                showingDeleteConfirm.toggle()
            }
            .accentColor(.red)
        }
    }

    var body: some View {
        Form {
            settingsSection
            colourSection
            footerSection
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(
                title: Text("Delete project"),
                message: Text("Are you sure you want to delete this project?" +
                                " You will also delete all the items it contains."),
                primaryButton: .default(Text("Delete"), action: delete),
                secondaryButton: .cancel())
        }
    }

    /// A view that provides a custom colour picker from the custom project colours.
    ///
    /// - Parameter item: Colour name value as String.
    /// - Returns: Custom colour picker view.
    private func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == colour {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            colour = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(item == colour ? [.isButton, .isSelected] : .isButton)
        .accessibilityHint(LocalizedStringKey(item))
    }

    /// Updates the `project` instance with the State object values.
    ///
    /// The changes made during the function will not be committed to the
    /// backing store until the view disappears.
    func update() {
        project.title = title
        project.detail = detail
        project.color = colour
    }

    /// Removes the project from store, and then dismisses the view.
    ///
    /// The changes made during this function will not be committed to the
    /// backing store until the view disappears. The view is dismissed by using
    /// the presentation mode for the view.
    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
            .environmentObject(DataController.preview)
    }
}
