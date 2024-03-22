//
//  View+Additions.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

//
//  View+Additions.swift
//  Sample Project Renamed
//
//  Created by Andrii Momot on 04.03.2024.
//

import SwiftUI

extension View {
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}

