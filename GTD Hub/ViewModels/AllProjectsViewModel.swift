//
//  AllProjectsViewModel.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 4/12/23.
//

import Foundation
import SwiftUI

class AllProjectsViewModel: ObservableObject {
    @Published var allProjectItems: [Project] = []
    weak var coordinator: ProjectActionCoordinatorProtocol?

    

    init() {
  
        loadProjects()
    }
    
    func addProject(title: String, dueDate: Date) {
        let newProject = Project(title: title, dueDate: dueDate)
        allProjectItems.append(newProject)
        saveProjects()
    }
    
    func loadProjects() {
        if let savedProjects = UserDefaults.standard.object(forKey: "projects") as? Data {
            let decoder = JSONDecoder()
            if let loadedProjects = try? decoder.decode([Project].self, from: savedProjects) {
                allProjectItems = loadedProjects
            }
        }
    }
    
    func saveProjects() {
        let encoder = JSONEncoder()
        if let encodedProjects = try? encoder.encode(allProjectItems) {
            UserDefaults.standard.set(encodedProjects, forKey: "projects")
        }
    }
    
    func removeProject(at indexSet: IndexSet) {
        allProjectItems.remove(atOffsets: indexSet)
        saveProjects()
    }
    
    func updateProjectNextAction(project: Project) {
        project.updateNextAction()
        saveProjects()
    }
    
    func editProject(project: Project, newTitle: String, newDueDate: Date) {
        project.edit(title: newTitle, dueDate: newDueDate)
        saveProjects()
    }
    
    func updateProjectActiveStatus(project: Project) {
        project.updateActiveStatus()
        saveProjects()
    }
    
    func updateProjectDoneStatus(project: Project) {
        project.updateDone()
        saveProjects()
    }
    

    
    func findProject(by id: String) -> Project? {
        return allProjectItems.first(where: { $0.id == id })
    }
}
