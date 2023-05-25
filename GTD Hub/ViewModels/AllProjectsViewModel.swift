//
//  AllProjectsViewModel.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 4/12/23.
//

import Foundation

class AllProjectsViewModel: ObservableObject {
    
    @Published var coordinator: ProjectActionCoordinator
    
    init(coordinator: ProjectActionCoordinator) {
        self.coordinator = coordinator
    }
    
    var allProjectItems: [Project] {
        return coordinator.projects
    }

    func addProject(title: String, dueDate: Date) {
        let newProject = Project(title: title, dueDate: dueDate)
        coordinator.projects.append(newProject)
        objectWillChange.send()  // Manually trigger a view update
    }

    func removeProject(at indexSet: IndexSet) {
        coordinator.projects.remove(atOffsets: indexSet)
        objectWillChange.send()  // Manually trigger a view update
    }
    
    func updateProjectActiveStatus(project: Project) {
        coordinator.toggleActiveStatus(for: project.id)
        objectWillChange.send()  // Manually trigger a view update
    }

    func updateProjectActionInfo(project: Project) {
        coordinator.updateNextAction(for: project.id)
        coordinator.updateCompletionStatus(for: project.id)
        objectWillChange.send()  // Manually trigger a view update
    }
    
    func editProject(project: Project, newTitle: String, newDueDate: Date) {
        if let index = coordinator.projects.firstIndex(where: { $0.id == project.id }) {
            coordinator.projects[index] = project.edit(title: newTitle, dueDate: newDueDate)
            objectWillChange.send()  // Manually trigger a view update
        }
    }

    func removeActionFromProject(projectId: UUID, actionId: UUID) {
        coordinator.removeActionFromProject(actionId: actionId, from: projectId)
        objectWillChange.send()  // Manually trigger a view update
    }
    
    func removeAllInactiveProjects() {
        coordinator.projects.removeAll(where: { !$0.isActive })
        objectWillChange.send()  // Manually trigger a view update
    }
}
