//
//  RootContentView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 20.03.2024.
//

import SwiftUI

struct RootContentView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var didShowLoading = false
    
    var body: some View {
        Group {
            if didShowLoading {
                if viewModel.user != nil {
                    TabBarView()
                        .environmentObject(viewModel)
                } else {
                    AgreementsView()
                        .environmentObject(viewModel)
                }
            } else {
                LoadingView(onDidLoad: $didShowLoading)
            }
        }
    }
}

struct RootContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootContentView()
    }
}
