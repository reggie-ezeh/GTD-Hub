//
//  ProjectPageView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/12/23.
//


import SwiftUI

struct ProjectPageView: View {
    @EnvironmentObject var allProjectsViewModel: AllProjectsViewModel
    @EnvironmentObject var nextActionsViewModel: NextActionsViewModel
    @State private var showActionSheet = false
    @State private var showTimelineView = false
    @State private var showAddActionView = false
    @State private var showEditProjectView = false
    
    let projectId: UUID
    
    var project: Project? {
        allProjectsViewModel.allProjectItems.first { $0.id == projectId }
    }
    
    //Sort actions by their due dates. actions with no due date are placed at the end
    var projectActions: [Action] {
        let actions = nextActionsViewModel.coordinator.actions.filter { action in
            project?.actionIds.contains(action.id) ?? false
        }
        return actions.sorted(by: { ($0.dueDate ?? Date.distantFuture) < ($1.dueDate ?? Date.distantFuture) })
    }


    
    var body: some View {

        GeometryReader { geometry in
            VStack (spacing: 0) {
                VStack {

                    
                    Text(project?.title ?? "")
                        .font(.title)
                        .foregroundColor(Color(hue: 0.663, saturation: 0.953, brightness: 0.896))
                        .padding(.bottom, 18.0)
                    
                    
                    if let nextActionId = project?.nextAction,
                       let nextAction = nextActionsViewModel.allActionItems.first(where: { $0.id == nextActionId }) {
                        VStack {
                            Text("Up Next: \(nextAction.title)")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            nextAction.dueDate.map { dueDate in
                                Text("due on: \(DateFormatter.localizedString(from: dueDate, dateStyle: .short, timeStyle: .none))")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                            }
                        }

                    }

                    
                    VStack(alignment: .leading) {
                        Text("Progress: \(project?.completionPercentage ?? 0)%")
                            .font(.headline)
                        
                        GeometryReader { geometry in
                            ProgressBar(progress: Float((project?.completionPercentage ?? 0)) / 100.0)
                                .frame(height: 15)
                                .frame(width: geometry.size.width - 30)
                        }
                        .frame(height: 4.0)
                    }
                    .padding(.vertical, 14.0)
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("Timeline View")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                            Toggle("", isOn: $showTimelineView)
                                .labelsHidden()
                        }
                    }
                    .padding([.top, .leading, .trailing], 2.0)

                    Text("Project Actions")
                        .font(.headline)
                        .padding(.top, 6.0)
                    
                    Text("Tap on actions to mark them complete")
                        .foregroundColor(.orange)
                        .font(.caption)

                    
                }
                .padding(.horizontal)

                VStack {

                    if showTimelineView {
                        TimelineView(actions: projectActions, viewModel: nextActionsViewModel)
                    } else {
                        List {
                            ForEach(projectActions.sorted(by: { ($0.dueDate ?? Date.distantFuture) < ($1.dueDate ?? Date.distantFuture) })) { action in
                                ActionItemView(action: action, actionCompletion: {
                                    nextActionsViewModel.updateActionCompletionStatus(inputAction: action)
                                    if let project = project {
                                        allProjectsViewModel.updateProjectActionInfo(project: project)
                                    }
                                }, color: action.isCompleted ? .green : .black)
                            }
                        }
                        
                    }
                    
                    
                }
                .frame(height: geometry.size.height * 0.50)
                .padding(.horizontal)

            }
        }
        
        
    
        
        
        
        
        
        
        
        .padding(.bottom, 40.0)
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
                    if let project = project,
                       let projectIndex = allProjectsViewModel.allProjectItems.firstIndex(where: { $0.id == project.id }) {
                        allProjectsViewModel.removeProject(at: IndexSet(integer: projectIndex))
                    }
                },
                .default(Text(project?.isActive ?? false ? "Mark Project as Done" : "Unmark Done")) {
                    if let project = project {
                        allProjectsViewModel.updateProjectActiveStatus(project: project)
                    }
                },
                .cancel()
            ])
        }
        .sheet(isPresented: $showAddActionView) {
            AddActionView(associatedProjectId: projectId)
                .environmentObject(nextActionsViewModel)
        }
        .sheet(isPresented: $showEditProjectView) {
            if let project = project {
                EditProjectView(project: project)
                    .environmentObject(allProjectsViewModel)
            }
        }
        .onAppear {
            if let project = project {
                allProjectsViewModel.updateProjectActionInfo(project: project)
            }
        }
        
        
        
    }
}

struct ProjectPageView_Previews: PreviewProvider {
    static var previews: some View {
        let coordinator: ProjectActionCoordinator = ProjectActionCoordinator()
        let allProjectsVM = AllProjectsViewModel(coordinator: coordinator)
        let nextActionsVM = NextActionsViewModel(coordinator: coordinator)
        ProjectPageView(projectId: UUID()).environmentObject(allProjectsVM).environmentObject(nextActionsVM)
    }
}



