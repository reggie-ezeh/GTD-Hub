//
//  ActionItemView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 3/27/23.
//

import SwiftUI


struct ActionItemView: View {
    let action: Action
    let actionCompletion: () -> Void
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(action.title)
                    .font(.headline)
                    .foregroundColor(color)
                Text(dueOrCompletedDateText)
                    .font(.subheadline)
                    .foregroundColor(color)
            }
            Spacer()
            Button(action: actionCompletion) {
                Image(systemName: action.isCompleted ? "checkmark.circle.fill" : "circle")
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(color)
        }
        .padding()
    }

    private var dueOrCompletedDateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        
        if action.isCompleted, let completionDate = action.completionDate {
            return "Completed on: \(formatter.string(from: completionDate))"
        } else if let dueDate = action.dueDate {
            return "Due on: \(formatter.string(from: dueDate))"
        } else {
            return "No date"
        }
    }
}

struct ActionItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActionItemView(
                action: Action(id: UUID(), title: "Incomplete Action", isCompleted: false, dueDate: Date(), completionDate: nil),
                actionCompletion: {},
                color: .black
            )
            ActionItemView(
                action: Action(id: UUID(), title: "Completed Action", isCompleted: true, dueDate: Date(), completionDate: Date()),
                actionCompletion: {},
                color: .green
            )
        }
        .previewLayout(.sizeThatFits)
    }
}
