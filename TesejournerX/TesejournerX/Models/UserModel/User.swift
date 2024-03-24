//
//  User.swift
//  TesejournerX
//
//  Created by Andrii Momot on 24.03.2024.
//

import Foundation

struct User: Codable {
    var budget: Budget = .init()
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
