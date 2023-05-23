//
//  NextActionsViewModel.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 3/29/23.
//

import Foundation

//This class handles the logic for the Next Actions view page
//ObservalbeObject makes this appear as an observable object
class NextActionsViewModel: ObservableObject{
    
    @Published var allActionItems:[Action] = [] {
        didSet{
            saveActions()
        }
    }
    
    @Published var completedActionItems:[Action] = [] {
        didSet{
            saveActions()
        }
    }
    
    @Published var allProjectItems:[Project] = []

    
    let allActionItemsKey = "actions_list"
    let completedActionItemsKey = "completed_actions_list"
    
    weak var coordinator: ProjectActionCoordinatorProtocol?


    func removeAction(at offsets: IndexSet) {
        allActionItems.remove(atOffsets: offsets)
    }
    
    func renameActionTitle(inputAction: Action, newTitle: String) {
        if let index = allActionItems.firstIndex(where: {$0.id == inputAction.id}) {
            allActionItems[index] = inputAction.updateTitle(newTitle: newTitle)
        }
    }
    
    func updateActionDueDate(inputAction: Action, newDueDate: Date) {
        if let index = allActionItems.firstIndex(where: {$0.id == inputAction.id}) {
            allActionItems[index] = inputAction.updateDueDate(newDueDate: newDueDate)
        }
    }
    
    func moveAction( from: IndexSet, to: Int){
        allActionItems.move(fromOffsets: from, toOffset: to)
    }
    
    func addActionItem(title: String, dueDate: Date, selectedProjectIds: [String]){
        let newAction = Action(title: title, isCompleted: false, projects: selectedProjectIds)
        allActionItems.append(newAction)

        // Add the new action to each selected project
        for projectId in selectedProjectIds {
            if let project = allProjectsViewModel.findProject(by: projectId) {
                allProjectsViewModel.addActionToProject(action: newAction, to: project)
            }
        }
    }

    
    func updateActionCompletionStatus(inputAction: Action){
        if let index = allActionItems.firstIndex(where: {$0.id == inputAction.id}){
            //replace that same action with a new Action object with the opposite completion status
            let updatedAction = inputAction.updateCompletion()
            allActionItems[index] = updatedAction
            
            // If updated action is complete, move it from allActionItems to completedActionItems
            if updatedAction.isCompleted {
                completedActionItems.append(updatedAction)
                allActionItems.remove(at: index)
            }
        }
    }
    
    func saveActions(){
        if let encoded = try? JSONEncoder().encode(allActionItems){
            UserDefaults.standard.set(encoded, forKey: allActionItemsKey)
        }
        if let encodedCompleted = try? JSONEncoder().encode(completedActionItems){
            UserDefaults.standard.set(encodedCompleted, forKey: completedActionItemsKey)
        }
    }
    
    func getActions(){
        guard let actionsData = UserDefaults.standard.data(forKey: allActionItemsKey) else {return}
        guard let decoded = try? JSONDecoder().decode([Action].self, from: actionsData) else {return}
        
        guard let completedActionsData = UserDefaults.standard.data(forKey: completedActionItemsKey) else {return}
        guard let decodedCompleted = try? JSONDecoder().decode([Action].self, from: completedActionsData) else {return}
        
        self.allActionItems = decoded
        self.completedActionItems = decodedCompleted
    }
}

