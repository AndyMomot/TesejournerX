//
//  User.swift
//  TesejournerX
//
//  Created by Andrii Momot on 24.03.2024.
//

import Foundation

struct User: Codable {
    private var id = UUID().uuidString
    var budget: Budget = .init()
    var budgetItems: [BudgetItem] = []
    
    private(set) lazy var income = budgetItems.filter {$0.type == .income}.reduce(0) {$0 + $1.sum}
    private(set) lazy var costs = budgetItems.filter {$0.type == .cost}.reduce(0) {$0 + $1.sum}
    private(set) lazy var balance = income - costs
}

extension User {
    struct Budget: Codable {
        var income: Double = .zero
        var costs: Double = .zero
        var together: Double {
            income - costs
        }
    }
}

extension User {
    struct BudgetItem: Codable {
        var id = UUID().uuidString
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

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
