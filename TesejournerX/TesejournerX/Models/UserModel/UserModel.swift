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
    var budget: Budget = .init()
    var budgetItems: [BudgetItem] = []
    
    private(set) lazy var income = budgetItems.filter {$0.type == .income}.reduce(0) {$0 + $1.sum}
    private(set) lazy var costs = budgetItems.filter {$0.type == .cost}.reduce(0) {$0 + $1.sum}
    private(set) lazy var balance = income - costs
}

extension UserModel {
    struct Budget: Codable {
        var income: Double = .zero
        var costs: Double = .zero
        var together: Double {
            income - costs
        }
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
