//
//  AuthViewModel.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var user: UserModel?
    
    init() {
        Task {
            user = try? UserDefaultsService.getUser()
        }
    }
    
    func signIn() {
        let baseUserModel = UserModel()
        try? UserDefaultsService.saveUser(model: baseUserModel)
        user = try? UserDefaultsService.getUser()
        
    }

    func signOut() {
        user = nil
        UserDefaultsService.removeAll()
    }
}
