//
//  ProjectActionCoordinator.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/23/23.
//

import Foundation

protocol ProjectActionCoordinatorProtocol {
    func addActionToProject(action: Action, to projectId: UUID)
    func removeActionFromProject(actionId: UUID, from projectId: UUID)
    func updateNextAction(for projectId: UUID)
    func updateCompletionStatus(for projectId: UUID)
}

class ProjectActionCoordinator: ObservableObject, ProjectActionCoordinatorProtocol {
    
    @Published var projects: [Project] {
        didSet {
            saveProjects()
        }
    }
    @Published var actions: [Action] {
        didSet {
            saveActions()
        }
    }
    
    let projectsKey = "project_list"
    let actionsKey = "actions_list"

    init(projects: [Project] = [], actions: [Action] = []) {
        self.projects = projects
        self.actions = actions
        loadProjects()
        loadActions()
    }
    
    func saveProjects() {
        if let encoded = try? JSONEncoder().encode(projects){
            UserDefaults.standard.set(encoded, forKey: projectsKey)
        }
    }
    
    func loadProjects() {
        guard let projectsData = UserDefaults.standard.data(forKey: projectsKey),
              let decodedProjects = try? JSONDecoder().decode([Project].self, from: projectsData) else {
            return
        }
        self.projects = decodedProjects
    }
    
    func saveActions() {
        if let encoded = try? JSONEncoder().encode(actions){
            UserDefaults.standard.set(encoded, forKey: actionsKey)
        }
    }
    
    func loadActions() {
        guard let actionsData = UserDefaults.standard.data(forKey: actionsKey),
              let decodedActions = try? JSONDecoder().decode([Action].self, from: actionsData) else {
            return
        }
        self.actions = decodedActions
    }
    
    func getActionById(id: UUID) -> Action? {
        return actions.first(where: { $0.id == id })
    }
    
    func addActionToProject(action: Action, to projectId: UUID) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == projectId }) else { return }
        projects[projectIndex].actionIds.append(action.id)
        
        // After adding an action, update the nextAction and completionStatus
        updateNextAction(for: projectId)
        updateCompletionStatus(for: projectId)
    }
    
    func removeActionFromProject(actionId: UUID, from projectId: UUID) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == projectId }) else { return }
        projects[projectIndex].actionIds.removeAll { $0 == actionId }

        updateNextAction(for: projectId)
        updateCompletionStatus(for: projectId)
    }
    
    func updateNextAction(for projectId: UUID) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == projectId }) else { return }
        
        let actionObjects = actions.filter { action in
            projects[projectIndex].actionIds.contains(action.id)
        }
        
        let incompleteActions = actionObjects.filter { !$0.isCompleted }
        let nextAction = incompleteActions.sorted { $0.dueDate ?? .distantFuture < $1.dueDate ?? .distantFuture }.first
        
        projects[projectIndex].nextAction = nextAction?.id
    }

    func updateCompletionStatus(for projectId: UUID) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == projectId }) else { return }
        let completedCount = projects[projectIndex].actionIds.filter { actionId in
            actions.first(where: { $0.id == actionId })?.isCompleted == true
        }.count
        if !projects[projectIndex].actionIds.isEmpty {
            let newCompletionPercentage = Int((Double(completedCount) / Double(projects[projectIndex].actionIds.count)) * 100)
            projects[projectIndex].completionPercentage = newCompletionPercentage
            projects[projectIndex].isCompleted = newCompletionPercentage == 100
        } else {
            projects[projectIndex].completionPercentage = 0
            projects[projectIndex].isCompleted = false
        }
    }
    
    func getProjects(for actionId: UUID) -> [Project] {
        return projects.filter { $0.actionIds.contains(actionId) }
    }
    
    
    func toggleActiveStatus(for projectId: UUID) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == projectId }) else { return }
        projects[projectIndex].isActive = !projects[projectIndex].isActive

        // Also update the done date whenever the active status changes
        updateDoneDate(for: projectId)
    }

    func updateDoneDate(for projectId: UUID) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == projectId }) else { return }
        // If the project is active, set doneDate to nil; otherwise, set it to the current date
        projects[projectIndex].doneDate = projects[projectIndex].isActive ? nil : Date()
    }

}
