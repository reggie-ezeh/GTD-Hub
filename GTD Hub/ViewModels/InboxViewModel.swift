//
//  InboxViewModel.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/19/23.
//

import Foundation

class InboxViewModel: ObservableObject {
    @Published var allInboxItems: [InboxItem] = []

    init() {
        loadInboxItems()
    }

    func addInboxItem(title: String, captureDate: Date) {
        let newItem = InboxItem(title: title, captureDate: captureDate)
        allInboxItems.append(newItem)
        saveInboxItems()
    }

    func getInboxItem(id: String) -> InboxItem? {
        return allInboxItems.first { $0.id == id }
    }

    func deleteInboxItem(id: String) {
        allInboxItems.removeAll { $0.id == id }
        saveInboxItems()
    }

    private func loadInboxItems() {
        if let savedInboxItems = UserDefaults.standard.object(forKey: "inboxItems") as? Data {
            let decoder = JSONDecoder()
            if let loadedInboxItems = try? decoder.decode([InboxItem].self, from: savedInboxItems) {
                allInboxItems = loadedInboxItems
            }
        }
    }

    private func saveInboxItems() {
        let encoder = JSONEncoder()
        if let encodedInboxItems = try? encoder.encode(allInboxItems) {
            UserDefaults.standard.set(encodedInboxItems, forKey: "inboxItems")
        }
    }
}

