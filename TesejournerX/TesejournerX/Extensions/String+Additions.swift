//
//  String+Additions.swift
//  TesejournerX
//
//  Created by Andrii Momot on 26.03.2024.
//

import Foundation

extension String {
    func toDateWith(format: Date.Format) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
}
