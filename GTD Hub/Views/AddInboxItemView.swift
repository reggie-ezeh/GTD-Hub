//
//  AddInboxItemView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/19/23.
//

import SwiftUI

struct AddInboxItemView: View {
    @EnvironmentObject var inboxViewModel: InboxViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var inputText = ""

    var body: some View {
            VStack {
                TextField("Write something…", text: $inputText)
            
                Button(action: saveButtonClicked) {
                    Text("Capture")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                }
                .disabled(!isInputValid())
            }
            .padding()
            .navigationTitle("Add an Inbox Item")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
    }

    private func isInputValid() -> Bool {
        return !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func saveButtonClicked() {
        if isInputValid() {
            inboxViewModel.addInboxItem(title: inputText, captureDate: Date())
            inputText = ""
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddInboxItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AddInboxItemView()
        }
    }
}


