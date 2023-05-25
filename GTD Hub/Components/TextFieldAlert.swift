//
//  TextFieldAlert.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/24/23.
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
