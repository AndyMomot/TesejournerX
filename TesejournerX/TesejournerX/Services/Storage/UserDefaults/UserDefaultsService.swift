//
//  UserDefaultsService.swift
//  TesejournerX
//
//  Created by Andrii Momot on 20.03.2024.
//

import Foundation

struct UserDefaultsService {
    private static let standard = UserDefaults.standard
}

// Remove data
extension UserDefaultsService {
    static func removeObject(for key: Keys) {
        standard.removeObject(forKey: key.rawValue)
    }
    
    static func removeAll() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            standard.removePersistentDomain(forName: bundleIdentifier)
        }
    }
}

// User
extension UserDefaultsService {
    static func saveUser(model: User) throws {
        do {
            let data = try JSONEncoder().encode(model)
            standard.set(data, forKey: Keys.user.rawValue)
        } catch {
            throw error
        }
    }
    
    static func getUser() throws -> User {
        do {
            let data = standard.object(forKey: Keys.user.rawValue) as? Data ?? Data()
            let item = try JSONDecoder().decode(User.self, from: data)
            return item
        } catch {
            throw error
        }
    }
}

// Personal catergories
extension UserDefaultsService {
    static func savePersonalCategory(_ item: Category) throws {
        do {
            var savedItems = getPersonalCategories()
            savedItems.append(item)
            let data = try JSONEncoder().encode(savedItems)
            standard.set(data, forKey: Keys.categories.rawValue)
        } catch {
            throw error
        }
    }
    
    static func getPersonalCategories() -> [Category] {
        let data = standard.object(forKey: Keys.categories.rawValue) as? Data ?? Data()
        let items = try? JSONDecoder().decode([Category].self, from: data)
        return items ?? []
    }
    
    static func deletePersonalCategory(_ item: Category) throws {
        do {
            var savedItems = getPersonalCategories()
            savedItems.removeAll(where: {$0.id == item.id})
            let data = try JSONEncoder().encode(savedItems)
            standard.set(data, forKey: Keys.categories.rawValue)
        } catch {
            throw error
        }
    }
}

// Keys
extension UserDefaultsService {
    enum Keys: String {
        case user
        case categories
    }
}
