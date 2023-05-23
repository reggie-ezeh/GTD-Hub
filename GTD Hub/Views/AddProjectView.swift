//
//  AddProjectView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/12/23.
//

import SwiftUI

struct AddProjectView: View {
    @EnvironmentObject var allProjectsViewModel: AllProjectsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var projectName: String
    @State private var dueDate: Date = Date()
    @State private var showAlert = false
    
    init(projectName: String = "") {
        _projectName = State(initialValue: projectName)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Project Name")) {
                TextField("Insert Project name", text: $projectName)
            }
            
            Section(header: Text("Due Date")) {
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            }
            
            Button(action: createButtonClicked) {
                Text("Create")
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Please enter a unique project name"), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("Add a new project")
        .navigationBarItems(trailing: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    private func projectNameExists() -> Bool {
        return allProjectsViewModel.allProjectItems.contains { project in
            project.title.lowercased() == projectName.lowercased()
        }
    }
    
    private func createButtonClicked() {
        if projectName.isEmpty || projectNameExists() {
            showAlert = true
        } else {
            allProjectsViewModel.addProject(title: projectName, dueDate: dueDate)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddProjectView().environmentObject(AllProjectsViewModel())
        }
    }
}

