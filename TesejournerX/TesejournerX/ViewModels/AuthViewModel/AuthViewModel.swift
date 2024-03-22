//
//  AuthViewModel.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var userID: String?
    
    init() {
        Task {
            userID = UserDefaultsService.userID
        }
    }
    
    func signIn() {
        UserDefaultsService.setUserID()
        userID = UserDefaultsService.userID
    }

    func signOut() {
        userID = nil
        UserDefaultsService.removeAll()
    }
}
