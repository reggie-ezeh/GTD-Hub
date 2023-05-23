//
//  AddReferenceView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/18/23.
//

import SwiftUI

struct AddReferenceView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String
    @ObservedObject var viewModel: ReferencesViewModel
    
    init(title: String = "", viewModel: ReferencesViewModel) {
        _title = State(initialValue: title)
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Form {
                HStack {
                    Text("Title:")
                    TextField("Enter the title...", text: $title)
                }
            }
            Button(action: saveButtonClicked) {
                Text("Save")
            }
            .padding()
        }
        .navigationTitle("Add a Reference Item")
        .navigationBarItems(trailing: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    private func saveButtonClicked() {
        if title.count >= 3 && title.count <= 200 {
            viewModel.addReferenceItem(title: title)
            title = ""
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddReferenceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddReferenceView(viewModel: ReferencesViewModel())
        }
    }
}

