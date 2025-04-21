// Models/User.swift
// ScholarHelp
//
// Created by Daniel Nuno on 4/18/25.
//

import Foundation
import CoreData

struct User: Identifiable {
    var id = UUID()
    var username: String
    var password: String
    var gradeClass: Int? = nil
    var isHelper: Bool = false

    init(entity: UserEntity) {
        self.id = entity.id ?? UUID()
        self.username = entity.username ?? ""
        self.password = entity.password ?? ""
        self.gradeClass = Int(entity.gradeClass)
        self.isHelper = entity.isHelper
    }

    init(id: UUID = UUID(),
         username: String,
         password: String,
         gradeClass: Int? = nil,
         isHelper: Bool = false) {
        self.id = id
        self.username = username
        self.password = password
        self.gradeClass = gradeClass
        self.isHelper = isHelper
    }
}
