//
//  TabBarViewModel.swift
//  TesejournerX
//
//  Created by Andrii Momot on 05.04.2024.
//

import Foundation

extension TabBarView {
    final class TabBarViewModel: ObservableObject {
        @Published var selection = TabBarSelectionView.main.rawValue
    }
}

extension TabBarView {
    enum TabBarSelectionView: Int {
        case main = 0
        case budget = 1
        case help = 2
        case settings = 3
    }
}
