//
//  UserModel.swift
//  ScholarHelp
//
//  Created by Daniel Nuno on 4/18/25.
//


import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ScholarHelp")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading Core Data stores: \(error.localizedDescription)")
            }
        }
    }
}

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
    
    init(id: UUID = UUID(), username: String, password: String, gradeClass: Int? = nil, isHelper: Bool = false) {
        self.id = id
        self.username = username
        self.password = password
        self.gradeClass = gradeClass
        self.isHelper = isHelper
    }
}

class UserManager: ObservableObject {
    @Published var currentUser: User?
    @Published var users: [User] = []
    
    private var viewContext: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }
    
    static let shared = UserManager()
    
    private init() {
        loadUsers()
        
        if users.isEmpty {
            addSampleUsers()
        }
    }
    
    private func loadUsers() {
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        
        do {
            let fetchedUsers = try viewContext.fetch(request)
            self.users = fetchedUsers.map { User(entity: $0) }
        } catch {
            print("Failed to fetch users: \(error)")
        }
    }
    
    private func addSampleUsers() {
        let sampleUsers = [
            User(username: "ivanovich", password: "test123", gradeClass: 0, isHelper: true),
            User(username: "alets", password: "test123", gradeClass: 3, isHelper: false),
            User(username: "daniel", password: "test123", gradeClass: 4, isHelper: false)
        ]
        
        for user in sampleUsers {
            let newUser = UserEntity(context: viewContext)
            newUser.id = user.id
            newUser.username = user.username
            newUser.password = user.password
            newUser.gradeClass = Int16(user.gradeClass ?? 0)
            newUser.isHelper = user.isHelper
        }
        
        saveContext()
        loadUsers()
    }
    
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func login(username: String, password: String) -> Bool {
        let cleanUser = username
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        let cleanPass = password
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let user = users.first(where: {
            $0.username.lowercased() == cleanUser && $0.password == cleanPass
        }) {
            currentUser = user
            return true
        }
        return false
    }
    
    func register(username: String, password: String) -> Bool {
        guard !users.contains(where: { $0.username.lowercased() == username.lowercased() }) else {
            return false
        }
        
        let newUserEntity = UserEntity(context: viewContext)
        let id = UUID()
        newUserEntity.id = id
        newUserEntity.username = username
        newUserEntity.password = password
        newUserEntity.gradeClass = 0
        newUserEntity.isHelper = false
        
        saveContext()
        
        let newUser = User(id: id, username: username, password: password)
        users.append(newUser)
        currentUser = newUser
        
        return true
    }
    
    func updateCurrentUserGrade(gradeClass: Int) {
        guard let user = currentUser else { return }
        
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        
        do {
            let results = try viewContext.fetch(request)
            if let userEntity = results.first {
                userEntity.gradeClass = Int16(gradeClass)
                saveContext()
                
                var updatedUser = user
                updatedUser.gradeClass = gradeClass
                save(user: updatedUser)
            }
        } catch {
            print("Failed to update user grade: \(error)")
        }
    }
    
    func setUserAsHelper(isHelper: Bool) {
        guard let user = currentUser else { return }
        
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        
        do {
            let results = try viewContext.fetch(request)
            if let userEntity = results.first {
                userEntity.isHelper = isHelper
                saveContext()
                
                var updatedUser = user
                updatedUser.isHelper = isHelper
                save(user: updatedUser)
            }
        } catch {
            print("Failed to update helper status: \(error)")
        }
    }
    
    private func save(user: User) {
        currentUser = user
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
        }
    }
    
    func getHelpers() -> [User] { users.filter { $0.isHelper } }
    func getNeedHelp() -> [User] { users.filter { ($0.gradeClass ?? 0) >= 3 } }
    
    func saveProfile(age: Int,
                     gender: Bool,
                     studyTime: Double,
                     gpa: Double,
                     absences: Int,
                     extracurricular: Bool) {

    }
}
