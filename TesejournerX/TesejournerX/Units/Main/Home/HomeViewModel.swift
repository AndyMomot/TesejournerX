//
//  HomeViewModel.swift
//  TesejournerX
//
//  Created by Andrii Momot on 03.04.2024.
//

import Foundation

extension HomeView {
    final class HomeViewModel: ObservableObject {
        func delete(item: UserModel.BudgetItem, completion: @escaping () -> Void) {
            DispatchQueue.main.async {
                do {
                    var user = try UserDefaultsService.getUser()
                    user.budgetItems.removeAll(where: {
                        $0.id == item.id
                    })
                    try UserDefaultsService.saveUser(model: user)
                } catch {
                    print(error.localizedDescription)
                }
                
                completion()
            }
        }
    }
    
    enum Home {
        enum TopTabBarItem: Int, CaseIterable {
            case days = 0
            case calendar = 1
            case month = 2
            case details = 3
            
            var title: String {
                switch self {
                case .days:
                    return "Dni"
                case .calendar:
                    return "Kalendarz"
                case .month:
                    return "Miesiąc"
                case .details:
                    return "Szczegóły"
                }
            }
        }
    }
}
