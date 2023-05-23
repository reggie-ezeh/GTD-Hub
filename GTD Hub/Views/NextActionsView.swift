//
//  NextActionsView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 3/26/23.
//

import SwiftUI



struct TextFieldAlert<Presenting>: View where Presenting: View {
    @State var invalidAlertTitle: String = ""
    @State var showInvalidAlert: Bool = false

    @Binding var isShowing: Bool
    @Binding var text: String
    let presenting: () -> Presenting
    let onSave: (String) -> Void
    
    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .fill(Color.black.opacity(0.4))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { isShowing = false }
                
                VStack {
                    Text("Rename")
                        .font(.headline)
                    
                    TextField("New action title", text: $text)
                        .padding()
                    
                    HStack {
                        Button("Save") {
                            if isValidAcion(inputText: text){
                                onSave(text)
                                isShowing = false
                            } else {
                                invalidAlertTitle = "Invalid Action Item"
                                showInvalidAlert.toggle()
                            }
                        }
                        
                        Spacer()
                        
                        Button("Cancel") {
                            isShowing = false
                        }
                    }
                    .padding()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
            } else {
                presenting()
                    .disabled(isShowing)
            }
        }
        .alert(isPresented: $showInvalidAlert, content: getInvalidAlert)
    }
    
    
    func isValidAcion(inputText: String) -> Bool {
        return inputText.count<2 ? false : true
    }
    func getInvalidAlert() -> Alert {
        return Alert(title: Text(invalidAlertTitle))
    }
}

struct DueDatePickerAlert<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    @State private var date: Date
    let presenting: () -> Presenting
    let onSave: (Date) -> Void
    
    init(isShowing: Binding<Bool>, selectedDate: Date, presenting: @escaping () -> Presenting, onSave: @escaping (Date) -> Void) {
        self._isShowing = isShowing
        self._date = State(initialValue: selectedDate)
        self.presenting = presenting
        self.onSave = onSave
    }
    
    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .fill(Color.black.opacity(0.4))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { isShowing = false }
                
                VStack {
                    Text("Change Due Date")
                        .font(.headline)
                    
                    DatePicker("Due Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .padding()
                    
                    HStack {
                        Button("Save") {
                            onSave(date)
                            isShowing = false
                        }
                        
                        Spacer()
                        
                        Button("Cancel") {
                            isShowing = false
                        }
                    }
                    .padding()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
            } else {
                presenting()
                    .disabled(isShowing)
            }
        }
    }
}


struct NextActionsView: View {
    @EnvironmentObject var nextActionsViewModel: NextActionsViewModel

    @State private var showDueDatePicker = false
    @State private var showTextFieldPopup = false
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    @State private var selectedAction: Action?

    var body: some View {
        List {
            ForEach(nextActionsViewModel.allActionItems)  { actionItem in
                ActionItemView(actionItem: actionItem)
                    .onTapGesture {
                        withAnimation(.linear) {
                            nextActionsViewModel.updateActionCompletionStatus(inputAction: actionItem)
                        }
                    }
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

                        // Implement "Add to existing Project" functionality
                    }
            }
            .onDelete(perform: nextActionsViewModel.removeAction)
            .onMove(perform: nextActionsViewModel.moveAction)
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
        .environmentObject(NextActionsViewModel())
    }
}


