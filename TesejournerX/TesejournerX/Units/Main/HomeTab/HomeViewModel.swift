//
//  HomeViewModel.swift
//  TesejournerX
//
//  Created by Andrii Momot on 03.04.2024.
//

import Foundation

extension HomeView {
    final class HomeViewModel: ObservableObject {
        
        @Published var currentDaysDate = Date()
        @Published var currentCalendarDate = Date()
        @Published var currentMonthDate = Date()
        @Published var currentDetailsDate = Date()
        
        @Published var topTabBarSelectedIndex = 0
        @Published var currentTabBarItem = Home.TopTabBarItem.days
        
        @Published var onPlusTapped = false
        @Published var onEdit = false
        @Published var showFavorites = false
        
        var topTabBarItems = Home.TopTabBarItem.allCases.sorted(by: {$0.rawValue < $1.rawValue}).map {$0.title}
        @Published var balanceInfoData: [BalanceStatusView.StatusModel] = [
            .init(name: "Dochód", value: .zero),
            .init(name: "Koszty", value: .zero),
            .init(name: "Łącznie", value: .zero)
        ]
        
        @Published var budgetItems: [UserModel.BudgetItem] = []
        @Published var budgetItemId: String?
        
        @Published var isSearchBarVisible = false
        @Published var searchTearm = ""
        
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
        
        func getUserData() {
            DispatchQueue.main.async {
                do {
                    var savedUser = try UserDefaultsService.getUser()
                    self.balanceInfoData = [
                        .init(name: "Dochód", value: savedUser.income),
                        .init(name: "Koszty", value: savedUser.costs),
                        .init(name: "Łącznie", value: savedUser.balance)
                    ]
                    
                    self.budgetItems = savedUser.budgetItems
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        func onDateSwithcerTapped(onLeft: Bool) {
            let value: Int = onLeft ? -1 : 1
            
            switch currentTabBarItem {
            case .days:
                currentDaysDate = currentDaysDate.addOrSubtract(component: .day, value: value)
            case .calendar:
                currentCalendarDate = currentCalendarDate.addOrSubtract(component: .month, value: value)
            case .month:
                currentMonthDate = currentMonthDate.addOrSubtract(component: .year, value: value)
            case .details:
                currentDetailsDate = currentDetailsDate.addOrSubtract(component: .year, value: value)
            }
        }
        
        func getTopTabBarTitle() -> String {
            switch currentTabBarItem {
            case .days:
                return currentDaysDate.toString(format: .dayMonthNameYear)
            case .calendar:
                return currentCalendarDate.toString(format: .monthNameYear)
            case .month:
                return currentMonthDate.toString(format: .year)
            case .details:
                return currentDetailsDate.toString(format: .year)
            }
        }
    }
}

extension HomeView {
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
