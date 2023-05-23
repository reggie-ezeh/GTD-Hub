//
//  ReferenceItem.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/18/23.
//

import Foundation

struct ReferenceItem: Identifiable, Codable {
    let id: String
    let title: String
    
    init(id: String = UUID().uuidString, title: String) {
        self.id = id
        self.title = title
    }
}
