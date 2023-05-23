//
//  Project.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 4/14/23.
//

import Foundation

struct Project: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let dueDate: Date?
    var actionIds: [UUID]
    var nextAction: UUID?
    var isActive: Bool
    var isCompleted: Bool
    let completionPercentage: Int
    var doneDate: Date?
    
    // Implementing Hashable protocol
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(id: UUID = UUID(), title: String, dueDate: Date? = nil, actions: [UUID] = [], nextAction: UUID? = nil, activeProject: Bool = true, isCompleted: Bool = false, completionPercentage: Int = 0, doneDate: Date? = nil) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.actionIds = actions
        self.nextAction = nextAction
        self.isActive = activeProject
        self.isCompleted = isCompleted
        self.completionPercentage = completionPercentage
        self.doneDate = doneDate
    }
    
    func edit(title: String? = nil, dueDate: Date? = nil, actions: [UUID]? = nil) -> Project {
        let newTitle = title ?? self.title
        let newDueDate = dueDate ?? self.dueDate
        let newActions = actions ?? self.actionIds
        return Project(id: id, title: newTitle, dueDate: newDueDate, actions: newActions, nextAction: nextAction, activeProject: isActive, isCompleted: isCompleted, completionPercentage: completionPercentage, doneDate: doneDate)
    }
    
    func updateActiveStatus() -> Project {
        return Project(id: id, title: title, dueDate: dueDate, actions: actionIds, nextAction: nextAction, activeProject: !isActive, isCompleted: isCompleted, completionPercentage: completionPercentage, doneDate: doneDate)
    }
    
    func updateNextAction() -> Project {
        let incompleteActions = actions.filter { !$0.isCompleted }
        let nextAction = incompleteActions.sorted { $0.dueDate ?? .distantFuture < $1.dueDate ?? .distantFuture }.first
        return Project(id: id, title: title, dueDate: dueDate, actions: actions, nextAction: nextAction, activeProject: isActive, isCompleted: isCompleted, completionPercentage: completionPercentage, doneDate: doneDate)
    }
    
    func updateCompletionStatus() -> Project {
        let completedCount = actions.filter { $0.isCompleted }.count
        let newCompletionPercentage = Int((Double(completedCount) / Double(actions.count)) * 100)
        let newIsCompleted = newCompletionPercentage == 100
        return Project(id: id, title: title, dueDate: dueDate, actions: actions, nextAction: nextAction, activeProject: isActive, isCompleted: newIsCompleted, completionPercentage: newCompletionPercentage, doneDate: doneDate)
    }
    
    func updateDone() -> Project {
        let newDoneDate = isActive ? Date() : nil
        return Project(id: id, title: title, dueDate: dueDate, actions: actionIds, nextAction: nextAction, activeProject: !isActive, isCompleted: isCompleted, completionPercentage: completionPercentage, doneDate: newDoneDate)
    }
    
    func removeAction(id: String) -> Project {
        let newActions = actions.filter { $0.id != id }
        return Project(id: self.id, title: title, dueDate: dueDate, actions: newActions, nextAction: nextAction, activeProject: isActive, isCompleted: isCompleted, completionPercentage: completionPercentage, doneDate: doneDate)
    }
    }

