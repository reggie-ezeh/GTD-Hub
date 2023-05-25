//
//  DueDatePickerAlert.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/24/23.
//

import SwiftUI

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


