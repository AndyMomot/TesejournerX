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
    var incomeItems: [BudgetItem] = []
    var costsItems: [BudgetItem] = []
    
    private(set) lazy var income = incomeItems.reduce(0) {$0 + $1.sum}
    private(set) lazy var costs = costsItems.reduce(0) {$0 + $1.sum}
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
        var date: String
        var sum: Double
        var category: Category
        var note: String
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
