//
//  NextActionsView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 3/26/23.
//

import SwiftUI

struct NextActionsView: View {
    @EnvironmentObject var nextActionsViewModel: NextActionsViewModel

    @State private var showDueDatePicker = false
    @State private var showTextFieldPopup = false
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    @State private var selectedAction: Action?

    var body: some View {
        List {
            ForEach(nextActionsViewModel.allActionItems) { actionItem in
                ActionItemView(
                    action: actionItem,
                    actionCompletion: {
                        withAnimation(.linear) {
                            nextActionsViewModel.updateActionCompletionStatus(inputAction: actionItem)
                        }
                    },
                    color: actionItem.isCompleted ? .green : .black
                )
                .contextMenu {
                    Button(action: {
                        withAnimation {
                            nextActionsViewModel.updateActionCompletionStatus(inputAction: actionItem)
                        }
                    }) {
                        Text(actionItem.isCompleted ? "Unmark Complete" : "Mark Complete")
                        Image(systemName: "checkmark.circle")
                    }

                    Button(action: {
                        self.selectedAction = actionItem
                        self.showTextFieldPopup.toggle()
                    }) {
                        Text("Rename")
                        Image(systemName: "pencil")
                    }

                    Button(action: {
                        self.selectedAction = actionItem
                        self.showDueDatePicker.toggle()
                    }) {
                        Text("Change Due Date")
                        Image(systemName: "calendar")
                    }

                    Menu("Add to Project") {
                        ForEach(nextActionsViewModel.allProjectItems, id: \.id) { project in
                            Button(project.title, action: {
                                nextActionsViewModel.addActionToProject(action: actionItem, projectId: project.id)
                            })
                        }
                    }
                }
            }
            .onDelete(perform: nextActionsViewModel.removeAction)
        }
        .navigationTitle("Next Actions")
        .navigationBarItems(
            leading: HStack {
                EditButton()
                NavigationLink(destination: ArchivedActionsView()) {
                    Image(systemName: "archivebox")
                }
            },
            trailing: NavigationLink(destination: AddActionView()) {
                Image(systemName: "plus")
            }
        )
        .textFieldAlert(isPresented: $showTextFieldPopup, text: $alertTitle) { inputText in
            if inputText.count >= 2 {
                nextActionsViewModel.renameActionTitle(inputAction: selectedAction!, newTitle: inputText)
            } else {
                alertTitle = "Invalid Action Item"
                showAlert.toggle()
            }
        }
        .dueDatePickerAlert(isPresented: $showDueDatePicker, selectedDate: Date()) { inputDate in
            nextActionsViewModel.updateActionDueDate(inputAction: selectedAction!, newDueDate: inputDate)
        }
        .alert(isPresented: $showAlert, content: getAlert)
    }

    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
}




extension View {
    func textFieldAlert(isPresented: Binding<Bool>, text: Binding<String>, onSave: @escaping (String) -> Void) -> some View {
        TextFieldAlert(isShowing: isPresented, text: text, presenting: { self }, onSave: onSave)
    }

    func dueDatePickerAlert(isPresented: Binding<Bool>, selectedDate: Date, onSave: @escaping (Date) -> Void) -> some View {
        DueDatePickerAlert(isShowing: isPresented, selectedDate: selectedDate, presenting: { self }, onSave: onSave)
    }
}

struct NextActionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NextActionsView()
        }
        .environmentObject(NextActionsViewModel(coordinator: ProjectActionCoordinator()))
    }
}


