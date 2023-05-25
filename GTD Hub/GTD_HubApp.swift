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


/*The AllProjectsViewModel and NextActionsViewModel will share a reference to the same list of projects.
 Any modification made to a project from AllProjectsViewModel, will also be reflected in NextActionsViewModel, and vice versa. */


@main
struct GTDHubApp: App {
    @StateObject var coordinator: ProjectActionCoordinator
    @StateObject var projectsViewModel: AllProjectsViewModel
    @StateObject var actionsViewModel: NextActionsViewModel
    @StateObject var inboxViewModel = InboxViewModel()
    @StateObject var referencesViewModel = ReferencesViewModel()
    
    init() {
        let instances = Self.setupInstances()
        _coordinator = StateObject(wrappedValue: instances.coordinator)
        _projectsViewModel = StateObject(wrappedValue: instances.projectsViewModel)
        _actionsViewModel = StateObject(wrappedValue: instances.actionsViewModel)
    }
    
    private static func setupInstances() -> (coordinator: ProjectActionCoordinator, projectsViewModel: AllProjectsViewModel, actionsViewModel: NextActionsViewModel) {
        let coordinator = ProjectActionCoordinator()
        let projectsViewModel = AllProjectsViewModel(coordinator: coordinator)
        let actionsViewModel = NextActionsViewModel(coordinator: coordinator)
        return (coordinator, projectsViewModel, actionsViewModel)
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
            .environmentObject(coordinator)
        }
    }
}






