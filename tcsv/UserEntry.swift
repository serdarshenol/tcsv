//
//  UserEntry.swift
//  tcsv
//
//  Created by Serdar Senol on 04/07/2025.
//

import Foundation

struct UserEntry: Identifiable, Codable, Hashable, Equatable {
    var id: UUID
    var group: String
    var name: String
    var email: String

    init(id: UUID = UUID(), group: String, name: String, email: String) {
        self.id = id
        self.group = group
        self.name = name
        self.email = email
    }
    
    static func == (lhs: UserEntry, rhs: UserEntry) -> Bool {
        return lhs.group == rhs.group &&
               lhs.name == rhs.name &&
               lhs.email == rhs.email
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(group)
        hasher.combine(name)
        hasher.combine(email)
    }
}
