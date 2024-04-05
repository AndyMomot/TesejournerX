//
//  TabBarView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var viewModel = TabBarViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $viewModel.selection) {
                HomeView()
                    .tag(TabBarSelectionView.main.rawValue)
                    .environmentObject(viewModel)
                
                BudgetView()
                    .tag(TabBarSelectionView.budget.rawValue)
                    .environmentObject(viewModel)
                
                HelpView()
                    .tag(TabBarSelectionView.help.rawValue)
                
                SettingsView()
                    .tag(TabBarSelectionView.settings.rawValue)
            }
            .tableStyle(.inset)
            .overlay(alignment: .bottom) {
                CustomTabBarView(selectedItem: $viewModel.selection)
            }
            .background(Color.red)
            .padding(.bottom, -geometry.safeAreaInsets.bottom)
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
        
        TabBarView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
    }
}
