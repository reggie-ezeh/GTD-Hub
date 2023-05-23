//
//  ActionItemView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 3/27/23.
//

import SwiftUI


struct ActionItemView: View {
    
    let actionItem: Action
    
    var body: some View {
        HStack{
            Image(systemName: actionItem.isCompleted ? "checkmark.circle" : "circle")
                .foregroundColor(actionItem.isCompleted ? .blue : .black)
            Text(actionItem.title)
            Spacer()
        }
        .padding(.vertical, 9.0)
        .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
        
    }
}

struct ActionItemView_Previews: PreviewProvider {
    
    static var item1 = Action (title: "action 1", isCompleted: true)

    static var previews: some View {
            ActionItemView(actionItem: item1)
    }
}
