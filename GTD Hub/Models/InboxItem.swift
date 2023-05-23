//
//  InboxItem.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/18/23.
//

import Foundation

class InboxItem: Identifiable, Codable {
    let id: String
    var title: String
    var captureDate: Date

    init(id: String = UUID().uuidString, title: String, captureDate: Date) {
        self.id = id
        self.title = title
        self.captureDate = captureDate
    }
}
