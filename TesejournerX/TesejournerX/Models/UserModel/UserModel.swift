//
//  User.swift
//  TesejournerX
//
//  Created by Andrii Momot on 24.03.2024.
//

import SwiftUI
import Combine

final class UserDataPublisher: ObservableObject {
    static let shared = UserDataPublisher()
    
    private init() {}
    
    let objectDidChange = PassthroughSubject<Void, Never>()
    
    func notifyChanges() {
        objectDidChange.send()
    }
}

struct UserModel: Codable {
    private(set) var id = 1
    var budgetItems: [BudgetItem] = []
    
    private(set) lazy var income = budgetItems.filter {$0.type == .income}.reduce(0) {$0 + $1.sum}
    private(set) lazy var costs = budgetItems.filter {$0.type == .cost}.reduce(0) {$0 + $1.sum}
    private(set) lazy var balance = income - costs
    
    func getGroupedBudgetItemsBy(_ components: Set<Calendar.Component>, with format: Date.Format) -> [[UserModel.BudgetItem]] {
        // Создание словаря, в котором ключи - это components, а значения - это массив элементов с этими components
        let groupedByMonth = Dictionary(grouping: budgetItems) { item -> String in
            let calendar = Calendar.current
            let components = calendar.dateComponents(components, from: item.date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format.rawValue
            if let date = calendar.date(from: components) {
                return dateFormatter.string(from: date)
            } else {
                return ""
            }
        }

        // Преобразование словаря в массив кортежей (ключ, значение) и сортировка его по дате первого элемента в каждом подмассиве
        let sortedGroupedData = groupedByMonth.sorted { first, second in
            guard let firstDate = first.value.first?.date, let secondDate = second.value.first?.date else {
                return false
            }
            return firstDate < secondDate
        }

        // Преобразование отсортированного массива кортежей обратно в массив массивов DataItem
        return sortedGroupedData.map { $0.value }
    }
}

extension UserModel {
    struct BudgetItem: Codable {
        var id = UUID().uuidString
        var isFavorite: Bool
        var type: ItemType
        var date: Date
        var sum: Double
        var category: Category
        var note: String
        
        enum ItemType: Int, Codable {
            case income = 0
            case cost = 1
            
            var title: String {
                switch self {
                case .income:
                    return "Dochód"
                case .cost:
                    return "Koszt"
                }
            }
        }
    }
}

extension UserModel: Equatable {
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        lhs.id == rhs.id
    }
}
