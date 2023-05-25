//
//  ProjectItemView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 4/14/23.
//




import SwiftUI

struct ProjectItemView: View {
    let project: Project
    
    var body: some View {
        VStack (spacing: 7){
            Text(project.title)
                .font(.system(size: 30))                .fontWeight(.bold)
                .foregroundColor(.black)
                .offset(y:20)
            ZStack {
                Image(systemName: "folder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250.0, height: 250.0)
                
                if project.completionPercentage == 100 {
                    Text("Completed!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .offset(y:20)
                } else if project.completionPercentage == 0 {

                    Text("Not Started!")
                        .font(.headline)
                        .foregroundColor(.orange)
                        .offset(y:20)
                    
                } else {
                    CircularProgressBar(progress: Double(project.completionPercentage) / 100)
                        .frame(width: 70, height: 70)
                        .offset(x: 0, y: 25)
                    
                }
            }
        }
        .padding()
    }
}

struct ProjectItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectItemView(project: Project(title: "Sample Project", dueDate: Date(), actions: []))
    }
}



        


