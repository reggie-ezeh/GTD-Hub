//
//  ActiveProjectsListView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/12/23.
//

import SwiftUI

struct ActiveProjectsListView: View {
    @EnvironmentObject var allProjectsViewModel: AllProjectsViewModel
    @State private var showArchivedProjectsListView = false
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 20) {
                    ForEach(allProjectsViewModel.allProjectItems.filter { $0.isActive })  { project in
                        NavigationLink(destination: ProjectPageView(projectId: project.id).environmentObject(allProjectsViewModel)) {
                            ProjectItemView(project: project)
                        }
                    }
                }
            }
            .navigationTitle("Active Projects")
            .navigationBarItems(leading: NavigationLink(destination: ArchivedProjectsListView().environmentObject(allProjectsViewModel), isActive: $showArchivedProjectsListView) {
                Image(systemName: "archivebox")
            }, trailing: NavigationLink(destination: AddProjectView()) {
                Image(systemName: "plus")
            }
            )
    }
}

struct ActiveProjectsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ActiveProjectsListView()
        }
        .environmentObject(AllProjectsViewModel(coordinator: ProjectActionCoordinator()))
    }
}
