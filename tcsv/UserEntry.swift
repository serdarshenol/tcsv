//
//  UserEntry.swift
//  tcsv
//
//  Created by Serdar Senol on 04/07/2025.
//

import Foundation

struct UserEntry: Identifiable, Codable, Hashable {
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
}
