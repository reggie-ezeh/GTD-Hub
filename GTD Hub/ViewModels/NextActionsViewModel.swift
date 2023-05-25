//
//  NextActionsViewModel.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 3/29/23.
//

import Foundation

//This class handles the logic for the Next Actions view page
//ObservalbeObject makes this appear as an observable object
class NextActionsViewModel: ObservableObject {
    
    @Published var coordinator: ProjectActionCoordinator

    var allActionItems:[Action] {
        coordinator.actions.filter { !$0.isCompleted }
    }
    
    var completedActionItems:[Action] {
        coordinator.actions.filter { $0.isCompleted }
    }
    
    var allProjectItems:[Project] {
        coordinator.projects
    }

    init(coordinator: ProjectActionCoordinator) {
        self.coordinator = coordinator
    }
    
    func removeAction(at indexSet: IndexSet) {
        for index in indexSet {
            let action = allActionItems[index]
            if let indexInCoordinator = coordinator.actions.firstIndex(where: {$0.id == action.id}) {
                coordinator.actions.remove(at: indexInCoordinator)
                objectWillChange.send()  // Manually trigger a view update
            }
        }
    }
    
    func renameActionTitle(inputAction: Action, newTitle: String) {
        if let index = coordinator.actions.firstIndex(where: {$0.id == inputAction.id}) {
            coordinator.actions[index] = inputAction.updateTitle(newTitle: newTitle)
            objectWillChange.send()  // Manually trigger a view update

        }

    }
    
    func updateActionDueDate(inputAction: Action, newDueDate: Date) {
        if let index = coordinator.actions.firstIndex(where: {$0.id == inputAction.id}) {
            coordinator.actions[index] = inputAction.updateDueDate(newDueDate: newDueDate)
        }
    }
    
    /**This function creates a new Action and appends it to the coordinator's actions array.
     It then loops through the selectedProjectIds and, for each one, finds the corresponding Project in the coordinator's projects array.
     It then appends the new action's id to the project's actionIds array.**/
    func addActionItem(title: String, dueDate: Date, selectedProjectIds: [UUID]) {
        let newAction = Action(title: title, isCompleted: false, dueDate: dueDate)
        coordinator.actions.append(newAction)
        objectWillChange.send()  // Manually trigger a view update


        // Update the selected projects with the new action's id.
        for projectId in selectedProjectIds {
            if let index = coordinator.projects.firstIndex(where: { $0.id == projectId }) {
                coordinator.projects[index].actionIds.append(newAction.id)
                objectWillChange.send()  // Manually trigger a view update
            }
        }

    }
    
    func addActionToProject(action: Action, projectId: UUID) {
        coordinator.addActionToProject(action: action, to: projectId)
    }
    
    func updateActionCompletionStatus(inputAction: Action){
        if let index = coordinator.actions.firstIndex(where: {$0.id == inputAction.id}){
            //replace that same action with a new Action object with the opposite completion status
            let updatedAction = inputAction.updateCompletion()
            coordinator.actions[index] = updatedAction
            objectWillChange.send()  // Manually trigger a view update

        }
    }
    
    func removeAllCompletedActions() {
        coordinator.actions.removeAll(where: { $0.isCompleted })
        objectWillChange.send()  // Manually trigger a view update
    }
}


