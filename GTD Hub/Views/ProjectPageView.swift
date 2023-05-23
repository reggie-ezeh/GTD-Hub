//
//  ProjectPageView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/12/23.
//


import SwiftUI

struct ProjectPageView: View {
    @EnvironmentObject var nextActionsViewModel: NextActionsViewModel
    @EnvironmentObject var allProjectsViewModel: AllProjectsViewModel
    @State private var showActionSheet = false
    @State private var showListView = true
    @State private var showAddActionView = false
    @State private var showEditProjectView = false
    
    let project: Project
    
    
    var body: some View {
        VStack {
            if let nextAction = project.nextAction {
                Text("Next Action: \(nextAction.title)")
            }
            
            Toggle(isOn: $showListView) {
                Text("Toggle between List and Timeline view")
            }
          
            // Date.distantFuture as the default value when the dueDate is nil. This ensures that actions without a due date will be sorted to the end of the list.
            if showListView {
                
                List {
                    ForEach(project.actions.sorted(by: { ($0.dueDate ?? Date.distantFuture) < ($1.dueDate ?? Date.distantFuture) })) { action in
                        Button(action: {
                            nextActionsViewModel.updateActionCompletionStatus(inputAction: action)
                        }) {
                            Text(action.title)
                        }
                    }
                }
            }
             else {
                            
                 TimelineView(actions: project.actions)
                        }
        }
        .navigationBarTitle(project.title, displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            showActionSheet = true
        }) {
            Image(systemName: "pencil")
        })
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Options"), buttons: [
                .default(Text("Create new Action")) {
                    showAddActionView = true
                },
                .default(Text("Edit Project")) {
                    showEditProjectView = true
                },
                .default(Text("Delete Project")) {
                                    if let projectIndex = allProjectsViewModel.allProjectItems.firstIndex(where: { $0.id == project.id }) {
                                        allProjectsViewModel.removeProject(at: IndexSet(integer: projectIndex))
                                    }
                                },
                                .default(Text(project.isActive ? "Mark Project as Done" : "Unmark Done")) {
                                    allProjectsViewModel.updateProjectDoneStatus(project: project)
                                },
                                .cancel()
                            ])
        }
        .sheet(isPresented: $showAddActionView) {
            AddActionView(associatedProject: project)
                .environmentObject(nextActionsViewModel)
                .environmentObject(allProjectsViewModel)
        }
        .sheet(isPresented: $showEditProjectView) {
            EditProjectView(project: project)
                .environmentObject(allProjectsViewModel)
        }
        .onAppear {
            allProjectsViewModel.updateProjectNextAction(project: project)
            testAddProjectAction(project: project)
        }
    }
    
    
    
    func testAddProjectAction(project: Project) {
        print("Action count: \(project.actions.count)")
        for action in project.actions {
            print("Action title: \(action.title)")
        }
    }
}

struct ProjectPageView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectPageView(project: Project(title: "Sample Project")).environmentObject(AllProjectsViewModel()).environmentObject(NextActionsViewModel())
    }
}


