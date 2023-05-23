//
//  GTD_HubApp.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 3/18/23.
//

import SwiftUI

/*
 MVVM
 
 MODEL: data point
 VIEW; UI
 VIEWMODEL: UI + DATA point
 */


protocol ProjectActionCoordinatorProtocol {
    func addActionToProject(action: Action, to projectId: UUID)
    func removeActionFromProject(action: Action, from projectId: UUID)
}


class ProjectActionCoordinator: ObservableObject, ProjectActionCoordinatorProtocol {
    @Published var projects: [Project]
    @Published var actions: [Action]

    init(projects: [Project], actions: [Action]) {
        self.projects = projects
        self.actions = actions
    }
    
    func addActionToProject(action: Action, to projectId: UUID) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == projectId }) else { return }
        projects[projectIndex].actionIds.append(action.id)
    }
    
    func removeActionFromProject(action: Action, from projectId: UUID) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == projectId }) else { return }
        projects[projectIndex].actionIds.removeAll { $0 == action.id }
    }
}



/*The AllProjectsViewModel and NextActionsViewModel will share a reference to the same list of projects. Any modification made to a project from AllProjectsViewModel, will also be reflected in NextActionsViewModel, and vice versa. */


@main
struct GTD_HubApp: App {
    @StateObject var projectsViewModel = AllProjectsViewModel()
    @StateObject var actionsViewModel = NextActionsViewModel()
    @StateObject var coordinator = ProjectActionCoordinator()
    @StateObject var inboxViewModel = InboxViewModel()
    @StateObject var referencesViewModel = ReferencesViewModel()

    init() {
        coordinator.projectsViewModel = projectsViewModel
        coordinator.actionsViewModel = actionsViewModel
        projectsViewModel.coordinator = coordinator
        actionsViewModel.coordinator = coordinator
    }

    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomePageView()
            }
            .environmentObject(projectsViewModel)
            .environmentObject(actionsViewModel)
            .environmentObject(inboxViewModel)
            .environmentObject(referencesViewModel)
        }
    }
}




