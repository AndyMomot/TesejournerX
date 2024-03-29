//
//  Date+Additions.swift
//  TesejournerX
//
//  Created by Andrii Momot on 25.03.2024.
//

import Foundation

extension Date {
    func toString(format: Format = .ddMMyy) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pl_PL")
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
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
    func addOrSubtract(component: Calendar.Component, value: Int) -> Date {
        let calendar = Calendar.current
        if let modifiedDate = calendar.date(byAdding: component, value: value, to: self) {
            return modifiedDate
        } else {
            return self
        }
    }
    
    func isDayEqual(to date: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.day, .month, .year], from: self)
        let components2 = calendar.dateComponents([.day, .month, .year], from: date)

        if let day1 = components1.day, let month1 = components1.month, let year1 = components1.year,
           let day2 = components2.day, let month2 = components2.month, let year2 = components2.year {
            if day1 == day2 && month1 == month2 && year1 == year2 {
               return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func isYearEqual(to date: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year], from: self)
        let components2 = calendar.dateComponents([.year], from: date)

        if let year1 = components1.year,
           let year2 = components2.year {
            if year1 == year2 {
               return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func getStartEndDaysOfMonts() -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.yyyy"

        if let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self)) {
            let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) ?? startDate

            dateFormatter.dateFormat = "dd.MM"
            let startDateString = dateFormatter.string(from: startDate)
            let endDateString = dateFormatter.string(from: endDate)
            
            return "\(startDateString) - \(endDateString)"
        } else {
            return "?? - ??"
        }
    }
}

extension Date {
    enum Format: String {
        case ddMM = "dd.MM"
        case ddMMyy = "dd.MM.yy"
        case dayMonthNameYear = "d MMMM. yyyy 'r.'"
        case monthNameYear = "MMMM. yyyy 'r.'"
        case month = "MMMM"
        case year = "yyyy 'r.'"
    }
}
