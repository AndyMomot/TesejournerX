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

// Personal Data
extension UserDefaultsService {
    static var userID: String? {
        standard.string(forKey: Keys.userId.rawValue)
    }
    
    static func setUserID() {
        let userID = UUID().uuidString
        standard.set(userID, forKey: Keys.userId.rawValue)
    }
}

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

extension UserDefaultsService {
    enum Keys: String {
        case userId
        case user
    }
}
