//
//  Action.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 3/27/23.
//

import Foundation

//Each object of this type represents an action item
//There is a one-to-many relationship from Project to Action, and a many-to-one relationship from Action to Project.
struct Action: Identifiable, Codable {
    
    let id: UUID
    let title: String
    let isCompleted: Bool
    let dueDate: Date?
    let completionDate: Date?
    let projectIds: [UUID]
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool, dueDate: Date? = nil, completionDate: Date? = nil, projectIds: [UUID] = []) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.completionDate = completionDate
        self.projectIds = projectIds
    }
    
    func updateCompletion() -> Action {
        // isCompleted will be false originally when the toggle is set to true
        let updatedCompletionDate = isCompleted ? nil : Date()
        return Action(id: id, title: title, isCompleted: !isCompleted, dueDate: dueDate, completionDate: updatedCompletionDate, projectIds: projectIds)
    }

    func updateTitle(newTitle: String) -> Action {
        return Action(id: id, title: newTitle, isCompleted: isCompleted, dueDate: dueDate, completionDate: completionDate, projectIds: projectIds)
    }

    func updateDueDate(newDueDate: Date) -> Action {
        return Action(id: id, title: title, isCompleted: isCompleted, dueDate: newDueDate, completionDate: completionDate, projectIds: projectIds)
    }
}

