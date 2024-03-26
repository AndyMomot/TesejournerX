//
//  AuthViewModel.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var user: User?
    
    init() {
        Task {
            user = try? UserDefaultsService.getUser()
        }
    }
    
    func signIn() {
        let baseUserModel = User()
        try? UserDefaultsService.saveUser(model: baseUserModel)
        user = try? UserDefaultsService.getUser()
        
    }

    func signOut() {
        user = nil
        UserDefaultsService.removeAll()
    }
}
