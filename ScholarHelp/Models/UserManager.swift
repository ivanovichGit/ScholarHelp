// Models/UserManager.swift
// ScholarHelp
//
// Created by Daniel Nuno on 4/18/25.
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

final class UserManager: ObservableObject {
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
            User(username: "alets",     password: "test123", gradeClass: 3, isHelper: false),
            User(username: "daniel",    password: "test123", gradeClass: 4, isHelper: false)
        ]

        for user in sampleUsers {
            let newEntity = UserEntity(context: viewContext)
            newEntity.id         = user.id
            newEntity.username   = user.username
            newEntity.password   = user.password
            newEntity.gradeClass = Int16(user.gradeClass ?? 0)
            newEntity.isHelper   = user.isHelper
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

    // attempts login; returns true on success
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

    // registers a new user; returns false if username exists
    func register(username: String, password: String) -> Bool {
        guard !users.contains(where: { $0.username.lowercased() == username.lowercased() }) else {
            return false
        }

        let newEntity = UserEntity(context: viewContext)
        let newId = UUID()
        newEntity.id         = newId
        newEntity.username   = username.trimmingCharacters(in: .whitespacesAndNewlines)
        newEntity.password   = password
        newEntity.gradeClass = 0
        newEntity.isHelper   = false

        saveContext()

        let newUser = User(id: newId, username: username, password: password)
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
            if let entity = results.first {
                entity.gradeClass = Int16(gradeClass)
                saveContext()
                var updated = user
                updated.gradeClass = gradeClass
                save(user: updated)
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
            if let entity = results.first {
                entity.isHelper = isHelper
                saveContext()
                var updated = user
                updated.isHelper = isHelper
                save(user: updated)
            }
        } catch {
            print("Failed to update helper status: \(error)")
        }
    }

    private func save(user: User) {
        currentUser = user
        if let idx = users.firstIndex(where: { $0.id == user.id }) {
            users[idx] = user
        }
    }

    func getHelpers() -> [User] {
        users.filter { $0.isHelper }
    }

    func getNeedHelp() -> [User] {
        users.filter { ($0.gradeClass ?? 0) >= 3 }
    }
}
