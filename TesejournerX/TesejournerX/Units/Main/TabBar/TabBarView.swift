//
//  TabBarView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import SwiftUI

struct TabBarView: View {
    @State private var selection = TabBarSelectionView.main.rawValue
    
    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $selection) {
                HomeView()
                    .tag(TabBarSelectionView.main.rawValue)
                
                Text("budget")
                    .tag(TabBarSelectionView.budget.rawValue)
                
                Text("help")
                    .tag(TabBarSelectionView.help.rawValue)
                
                Text("settings")
                    .tag(TabBarSelectionView.settings.rawValue)
            }
            .tableStyle(.inset)
            .overlay(alignment: .bottom) {
                CustomTabBarView(selectedItem: $selection)
            }
            .background(Color.red)
            .padding(.bottom, -geometry.safeAreaInsets.bottom)
        }
    }
}

private enum TabBarSelectionView: Int {
    case main = 0
    case budget = 1
    case help = 2
    case settings = 3
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
        
        TabBarView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
    }
}
