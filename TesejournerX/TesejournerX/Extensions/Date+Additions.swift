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
    
    func isToday() -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
    
    func getCurrent(period component: Calendar.Component) -> Int {
        let calendar = Calendar.current
        return calendar.component(component, from: Date())
    }
}

extension Date {
    enum Format: String {
        case ddMMyy = "dd.MM.yy"
    }
}
