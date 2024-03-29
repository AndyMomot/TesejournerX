//
//  HomeModels.swift
//  TesejournerX
//
//  Created by Andrii Momot on 29.03.2024.
//

import Foundation

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
