//
//  Double+Additions.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import Foundation

extension Double {
    func string(style: NumberFormatter.Style = .decimal,
                maximumFractionDigits: Int = 2,
                usesSeparator: Bool = false,
                decimalSeparator: String = ",") -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.usesGroupingSeparator = usesSeparator
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        numberFormatter.decimalSeparator = decimalSeparator

        if let formattedString = numberFormatter.string(from: NSNumber(value: self)) {
           return formattedString // Output: "2 500,00"
        } else {
            return ""
        }
    }
}
