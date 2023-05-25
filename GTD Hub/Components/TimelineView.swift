//
//  TimelineView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/12/23.
//

import SwiftUI

struct TimelineView: View {
    let actions: [Action]
    let viewModel: NextActionsViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(actions.sorted(by: { ($0.dueDate ?? Date.distantFuture) < ($1.dueDate ?? Date.distantFuture) })) { action in
                    HStack(alignment: .top, spacing: 8) {
                        Text(getFormattedDate(date: action.dueDate))
                            .foregroundColor(action.isCompleted ? .green : .gray)
                            
                        VStack {
                            Circle()
                                .frame(width: 8, height: 8)
                                .foregroundColor(.blue)
                            
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 2)
                        }
                        
                        ActionItemView(action: action, actionCompletion: {
                            viewModel.updateActionCompletionStatus(inputAction: action)
                        }, color: action.isCompleted ? .green : .black)
                        
                        Spacer()
                    }
                }
                
                .padding(.horizontal)
            }
        }
    }
    
    private func getFormattedDate(date: Date?) -> String {
        guard let date = date else {
            return "No date"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}



//struct TimelineView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimelineView()
//    }
//}
