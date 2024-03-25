//
//  Date+Additions.swift
//  TesejournerX
//
//  Created by Andrii Momot on 25.03.2024.
//

import Foundation

extension Date {
    func todayString(format: Format = .ddMMyy) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: Date())
    }
}

extension Date {
    enum Format: String {
        case ddMMyy = "dd.MM.yy"
    }
}
