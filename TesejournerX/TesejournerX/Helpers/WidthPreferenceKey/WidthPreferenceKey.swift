//
//  WidthPreferenceKey.swift
//  TesejournerX
//
//  Created by Andrii Momot on 04.04.2024.
//

import SwiftUI

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
