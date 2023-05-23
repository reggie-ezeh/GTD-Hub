//
//  ReferencesViewModel.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/18/23.
//

import Foundation

class ReferencesViewModel: ObservableObject {
    @Published var allReferenceItems: [ReferenceItem] = []

    init() {
        loadReferenceItems()
    }
    
    func addReferenceItem(title: String) {
        let newItem = ReferenceItem(title: title)
        allReferenceItems.append(newItem)
        saveReferenceItems()
    }

    func getReferenceItem(id: String) -> ReferenceItem? {
        return allReferenceItems.first { $0.id == id }
    }

    func deleteReferenceItem(id: String) {
        allReferenceItems.removeAll { $0.id == id }
        saveReferenceItems()
    }
    
    private func loadReferenceItems() {
        if let savedReferenceItems = UserDefaults.standard.object(forKey: "referenceItems") as? Data {
            let decoder = JSONDecoder()
            if let loadedReferenceItems = try? decoder.decode([ReferenceItem].self, from: savedReferenceItems) {
                allReferenceItems = loadedReferenceItems
            }
        }
    }
    
    private func saveReferenceItems() {
        let encoder = JSONEncoder()
        if let encodedReferenceItems = try? encoder.encode(allReferenceItems) {
            UserDefaults.standard.set(encodedReferenceItems, forKey: "referenceItems")
        }
    }
}

