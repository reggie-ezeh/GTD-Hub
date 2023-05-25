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
    var completionPercentage: Int
    var doneDate: Date?
    
    // Implementing Hashable protocol
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(id: UUID = UUID(), title: String, dueDate: Date? = nil,
         actions: [UUID] = [], nextAction: UUID? = nil, activeProject: Bool = true,
         isCompleted: Bool = false, completionPercentage: Int = 0, doneDate: Date? = nil) {
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
        return Project(id: id, title: newTitle, dueDate: newDueDate, actions: newActions,
                       nextAction: nextAction, activeProject: isActive, isCompleted: isCompleted,
                       completionPercentage: completionPercentage, doneDate: doneDate)
    }
    
    func updateActiveStatus() -> Project {
        return Project(id: id, title: title, dueDate: dueDate, actions: actionIds,
                       nextAction: nextAction, activeProject: !isActive,
                       isCompleted: isCompleted, completionPercentage: completionPercentage, doneDate: doneDate)
    }
        
    
    func updateDoneDate() -> Project {
        let newDoneDate = isActive ? Date() : nil
        return Project(id: id, title: title, dueDate: dueDate, actions: actionIds,
                       nextAction: nextAction, activeProject: !isActive,
                       isCompleted: isCompleted, completionPercentage: completionPercentage, doneDate: newDoneDate)
    }
    

    }

