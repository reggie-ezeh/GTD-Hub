//
//  EditProjectView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/12/23.
//

import SwiftUI

struct EditProjectView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var allProjectsViewModel: AllProjectsViewModel
    @State private var title: String
    @State private var dueDate: Date
    @State private var isTitleChanged = false
    @State private var isDueDateChanged = false
    let project: Project
    
    init(project: Project) {
        self.project = project
        _title = State(initialValue: project.title)
        _dueDate = State(initialValue: project.dueDate ?? Date())
    }
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .padding()
                }
            }
            .padding(.horizontal)
            
            Form {
                TextField("Title", text: $title)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                Section(header: Text("Actions")) {
                    ForEach(project.actionIds.indices, id: \.self) { index in
                        if let action = allProjectsViewModel.coordinator.getActionById(id: project.actionIds[index]) {
                            HStack {
                                Text(action.title)
                                Spacer()
                                Button(action: {
                                    allProjectsViewModel.removeActionFromProject(projectId: project.id, actionId: action.id)
                                }) {
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                allProjectsViewModel.editProject(project: project, newTitle: title, newDueDate: dueDate)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
            }
            //using .disabled so, if neither the title nor the due date is changed, the Save button will be disabled.
            .disabled(!(isTitleChanged || isDueDateChanged))
            .padding(.horizontal)
        }
        .background(Color.white)
        .cornerRadius(20)
        //using .onChange modifier to observe changes to title and dueDate, and set isTitleChanged and isDueDateChanged appropriately.
        .onChange(of: title) { _ in
            isTitleChanged = title != project.title
        }
        .onChange(of: dueDate) { _ in
            isDueDateChanged = dueDate != (project.dueDate ?? Date())
        }
    }
}


struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditProjectView(project: Project(title: "Sample Project")).environmentObject(AllProjectsViewModel(coordinator: ProjectActionCoordinator()))
        }
    }
}
