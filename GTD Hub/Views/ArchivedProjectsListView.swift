//
//  ArchivedProjectsListView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/12/23.
//

import SwiftUI

struct ArchivedProjectsListView: View {
    @EnvironmentObject var allProjectsViewModel: AllProjectsViewModel
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))]) {
                    ForEach(allProjectsViewModel.allProjectItems.filter { !$0.isActive }) { project in
                        NavigationLink(destination: ProjectPageView(project: project).environmentObject(allProjectsViewModel)) {
                            ProjectItemView(project: project)
                        }
                    }
                }
            }
            .navigationTitle("Archived Projects")
            
        }
}

struct ArchivedProjectsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArchivedProjectsListView().environmentObject(AllProjectsViewModel())
        }
    }
}
