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
    @State private var selectedProjectIds: [UUID] = []
    let associatedProjectId: UUID?
    
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    
    init(title: String = "", associatedProjectId: UUID? = nil) {
        self.associatedProjectId = associatedProjectId
        _titleTextField = State(initialValue: title)
        if let associatedProjectId = associatedProjectId {
            _selectedProjectIds = State(initialValue: [associatedProjectId])
        } else {
            _selectedProjectIds = State(initialValue: [])
        }
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
                        MultipleSelectionRow(title: project.title, isSelected: self.selectedProjectIds.contains(project.id)) {
                            if self.selectedProjectIds.contains(project.id) {
                                self.selectedProjectIds.removeAll(where: { $0 == project.id })
                            }
                            else {
                                self.selectedProjectIds.append(project.id)
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
        let coordinator: ProjectActionCoordinator = ProjectActionCoordinator()

        NavigationView {
            AddActionView()
        }
        .environmentObject(NextActionsViewModel( coordinator: coordinator))
        .environmentObject(AllProjectsViewModel(coordinator: coordinator))
    }
}




