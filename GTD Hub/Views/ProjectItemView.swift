//
//  ProjectItemView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 4/14/23.
//

import SwiftUI


import SwiftUI

struct ProjectItemView: View {
    let project: Project
    
    var body: some View {
        VStack {
            Text(project.title)
            ZStack {
                Image(systemName: "folder")
                    .resizable()
                    .scaledToFit()
                if project.completionPercentage == 100 {
                    Text("Completed!")
                        .foregroundColor(.green)
                } else if project.completionPercentage == 0 {
                    Text("Not Started!")
                        .foregroundColor(.orange)
                } else {
                    ProgressView(value: Double(project.completionPercentage) / 100)
                }
            }
        }
    }
}

struct ProjectItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectItemView(project: Project(title: "Sample Project", dueDate: Date(), actions: []))
    }
}



        


