//
//  AddActionView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 3/27/23.
//

import SwiftUI

struct AddActionView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var nextActionsViewModel: NextActionsViewModel
    @EnvironmentObject var allProjectsViewModel: AllProjectsViewModel

    @State private var titleTextField: String
    @State private var dueDate: Date = Date()
    @State private var showDatePicker: Bool = false
    @State private var selectedProjects: [Project] = []
    let associatedProject: Project?
    
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    
    init(title: String = "", associatedProject: Project? = nil) {
        self.associatedProject = associatedProject
        _titleTextField = State(initialValue: title)
        _selectedProjects = State(initialValue: associatedProject != nil ? [associatedProject!] : [])
    }
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Insert Action Title", text: $titleTextField)
                    .frame(height: 60.0)
                    .background(Color(.systemGray6))
                    .cornerRadius(3.0)
                
                HStack {
                    Text("Due Date:")
                    TextField("Select due date", text: .constant(dateFormatter.string(from: dueDate)))
                        .frame(height: 60.0)
                        .background(Color(.systemGray6))
                        .cornerRadius(3.0)
                        .onTapGesture {
                            showDatePicker.toggle()
                        }
                }
                if showDatePicker {
                    DatePicker("", selection: $dueDate, displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Text("Projects:")
                List {
                    ForEach(allProjectsViewModel.allProjectItems, id: \.self) { project in
                        MultipleSelectionRow(title: project.title, isSelected: self.selectedProjects.contains(project)) {
                            if self.selectedProjects.contains(project) {
                                self.selectedProjects.removeAll(where: { $0.id == project.id })
                            }
                            else {
                                self.selectedProjects.append(project)
                            }
                        }
                    }
                }
                .frame(height: 200)
                
                Button(action: addButtonClicked) {
                    Text("Add")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40.0)
                        .background(Color.accentColor)
                }
            }
            .padding(.all)
        }
        .navigationTitle("Add an Action Item")
        .navigationBarItems(trailing: Button("Cancel") {
                   presentationMode.wrappedValue.dismiss()
               })
        .alert(isPresented: $showAlert, content: getAlert)
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    func addButtonClicked() {
        if isValidAcion() {
            let selectedProjectIds = selectedProjects.map { $0.id }
            nextActionsViewModel.addActionItem(title: titleTextField, dueDate: dueDate, selectedProjectIds: selectedProjectIds)
            presentationMode.wrappedValue.dismiss()
        } else {
            alertTitle = "Invalid Action Item"
            showAlert.toggle()
        }
    }
    
    func isValidAcion() -> Bool {
        return titleTextField.count < 2 ? false : true
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
}

struct AddActionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddActionView()
        }
        .environmentObject(NextActionsViewModel(allProjectsViewModel: AllProjectsViewModel()))
        .environmentObject(AllProjectsViewModel())
    }
}



