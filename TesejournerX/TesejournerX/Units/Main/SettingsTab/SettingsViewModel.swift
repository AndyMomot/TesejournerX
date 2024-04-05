//
//  SettingsViewModel.swift
//  TesejournerX
//
//  Created by Andrii Momot on 05.04.2024.
//

import Foundation

extension SettingsView {
    final class SettingsViewModel: ObservableObject {
        @Published var userName = "👋"
        @Published var showSetUserNameAlert = false
        
        @Published var showCategories = false
        @Published var showWriteReview = false
        @Published var showUlubion = false
        @Published var showCalendar = false
        @Published var showBudgetSettings = false
        @Published var showHelp = false
        
        var defaultURL = URL(string: "https://www.google.com")
        
        var dataSource: [SettingsCell.CellType] = [
            .categoryConfiguration,
            .writeReview,
            .ulubion,
            .calendar,
            .budgetSettings,
            .help
        ]
        
        func getUser() -> UserModel? {
            do {
                return try UserDefaultsService.getUser()
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        
        func setUser(model: UserModel) {
            DispatchQueue.main.async {
                do {
                    try UserDefaultsService.saveUser(model: model)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        func getUserData() {
            DispatchQueue.main.async {
                do {
                    let user = try UserDefaultsService.getUser()
                    if user.name.isEmpty {
                        self.userName = "👋"
                    } else {
                        self.userName = user.name
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        func setUserName() {
            guard var user = getUser() else { return }
            user.name = userName
            setUser(model: user)
            getUserData()
        }
        
        func onCellTapped(with type: SettingsCell.CellType) {
            switch type {
            case .categoryConfiguration:
                showCategories.toggle()
            case .writeReview:
                showWriteReview.toggle()
            case .ulubion:
                showUlubion.toggle()
            case .calendar:
                showCalendar.toggle()
            case .budgetSettings:
                showBudgetSettings.toggle()
            case .help:
                showHelp.toggle()
            }
        }
    }
}
