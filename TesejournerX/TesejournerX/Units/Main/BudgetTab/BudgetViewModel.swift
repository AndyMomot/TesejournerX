//
//  BudgetViewModel.swift
//  TesejournerX
//
//  Created by Andrii Momot on 04.04.2024.
//

import Foundation

extension BudgetView {
    final class BudgetViewModel: ObservableObject {
        
        @Published private var currentIncomeDate = Date()
        @Published private var currentCostDate = Date()
        @Published var currentMonth = ""
        
        @Published var currentTabBarItem = TopTabBarItem.income
        @Published var topTabBarSelectedIndex = 0
        @Published var topTabBarItems = ["Dochód 0", "Koszty 0"]
        
        @Published var income: Double = .zero
        @Published var cost: Double = .zero
        @Published var balance: Double = .zero
        @Published var dataSource: [[UserModel.BudgetItem]] = []
        
        @Published var onSetBudget = false
        @Published var showFavorites = false
        @Published var isSearchBarVisible = false
        @Published var searchTearm = ""
        
        func getTopTabBarTitle() -> String {
            switch currentTabBarItem {
            case .income:
                return currentIncomeDate.toString(format: .monthNameYear)
            case .cost:
                return currentCostDate.toString(format: .monthNameYear)
            }
        }
        
        func onDateSwithcerTapped(onLeft: Bool) {
            let value: Int = onLeft ? -1 : 1
            
            switch currentTabBarItem {
            case .income:
                currentIncomeDate = currentIncomeDate.addOrSubtract(component: .month, value: value)
            case .cost:
                currentCostDate = currentCostDate.addOrSubtract(component: .month, value: value)
            }
            
            setMontName()
        }
        
        func getUser() -> UserModel? {
            return try? UserDefaultsService.getUser()
        }
        
        func setData() {
            setMontName()
            guard var user = getUser() else { return }
            income = user.income
            cost = user.costs
            balance = user.balance
            
            topTabBarItems = ["Dochód \(income.string(maximumFractionDigits: 1))",
                              "Koszty \(cost.string(maximumFractionDigits: 1))"]
            
            makeDataSource()
        }
        
        func setCurrentTabBarItem(index: Int) {
            guard let newItem = TopTabBarItem.init(rawValue: index) else { return }
            currentTabBarItem = newItem
            setMontName()
            makeDataSource()
        }
        
        func setMontName() {
            switch currentTabBarItem {
            case .income:
                currentMonth = currentIncomeDate.toString(format: .month).capitalized
            case .cost:
                currentMonth = currentCostDate.toString(format: .month).capitalized
            }
        }
        
        func makeDataSource() {
            guard let user = getUser() else { return }
            var itemsSortedByDate: [[UserModel.BudgetItem]] = []
            var groupedItemsByCategory: [String: [UserModel.BudgetItem]] = [:]
            
            switch currentTabBarItem {
            case .income:
                let items = user.budgetItems.filter { $0.type == .income }
                itemsSortedByDate = user.getGroupedBudgetItemsBy([.month, .year],
                                                                 with: .monthNameYear,
                                                                 items: items)
            case .cost:
                let items = user.budgetItems.filter { $0.type == .cost }
                itemsSortedByDate = user.getGroupedBudgetItemsBy([.month, .year],
                                                                 with: .monthNameYear,
                                                                 items: items)
            }
            
            for items in itemsSortedByDate {
                for item in items {
                    let category = item.category.name
                    if var itemsInCategory = groupedItemsByCategory[category] {
                        itemsInCategory.append(item)
                        groupedItemsByCategory[category] = itemsInCategory
                    } else {
                        groupedItemsByCategory[category] = [item]
                    }
                }
                
            }
            
            if searchTearm.isEmpty {
                dataSource = groupedItemsByCategory.map { $0.value }
            } else {
                dataSource = groupedItemsByCategory.filter {
                $0.key.localizedCaseInsensitiveContains(searchTearm)
                }.map { $0.value }
            }
        }
        
        func makeCellModel(with item: [UserModel.BudgetItem]) -> CellModel {
            let imageName = item.first?.category.image
            let categoryName = item.first?.category.name ?? ""
            let sum = item.reduce(0) {$0 + $1.sum}
            var maxValue: Double = .zero
            let currentValue = item.reduce(0) {$0 + $1.sum}
            
            if var user = getUser() {
                maxValue = user.income
            }
            
            return .init(imageName: imageName,
                         title: categoryName,
                         sum: sum,
                         maxValue: maxValue,
                         currentValue: currentValue)
        }
    }
}

extension BudgetView {
    enum TopTabBarItem: Int {
        case income = 0
        case cost = 1
    }
    
    struct CellModel {
        var imageName: String? = nil
        var title: String
        var sum: Double
        var maxValue: Double
        var currentValue: Double
    }
}
