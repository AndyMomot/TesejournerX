//
//  SettingsCell+Model.swift
//  TesejournerX
//
//  Created by Andrii Momot on 05.04.2024.
//

import Foundation

extension SettingsCell {
    enum CellType: Int {
        case categoryConfiguration = 0
        case writeReview = 1
        case ulubion = 2
        case calendar = 3
        case budgetSettings = 4
        case help = 5
        
        var imageName: String {
            switch self {
            case .categoryConfiguration:
                return Asset.signDivisionCircle.name
            case .writeReview:
                return Asset.signMinusCircle.name
            case .ulubion:
                return Asset.heart.name
            case .calendar:
                return Asset.calendar.name
            case .budgetSettings:
                return Asset.calculator.name
            case .help:
                return Asset.help.name
            }
        }
        
        var text: String {
            switch self {
            case .categoryConfiguration:
                return "Konfigurowanie kategorii"
            case .writeReview:
                return "Napisz recenzję "
            case .ulubion:
                return "Ulubione"
            case .calendar:
                return "Kalendarz"
            case .budgetSettings:
                return "Ustawienia Budżet"
            case .help:
                return "Pomoc i FAQ"
            }
        }
    }
}
