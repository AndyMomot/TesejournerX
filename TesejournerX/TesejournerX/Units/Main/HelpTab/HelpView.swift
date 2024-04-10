//
//  HelpView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 04.04.2024.
//

import SwiftUI

struct HelpView: View {
    @StateObject private var viewModel = HelpViewModel()
    private var bounts = UIScreen.main.bounds
    
    var body: some View {
        NavigationStack {
            ZStack {
                Colors.blue.swiftUIColor
                    .ignoresSafeArea()
                Asset.homeBg.swiftUIImage
                    .resizable()
                    .ignoresSafeArea(edges: .bottom)
                
                VStack(alignment: .leading) {
                    Text("Często zadawane pytania ")
                        .foregroundColor(.black)
                        .font(Fonts.LexendDeca.medium.swiftUIFont(size: 18))
                        .padding(.top, 20)
                        .padding(.horizontal, 26)
                    
                    ScrollView(showsIndicators: false) {
                        ForEach(viewModel.dataSource) { item in
                            HelpCell(model: item)
                        }
                    }
                    .padding(.horizontal, 26)
                }
                
                // MARK: Chat button
//                VStack {
//                    Spacer()
//                    HStack {
//                        Spacer()
//
//                        NavigationLink {
//                            let url = URL(string: viewModel.helpURL)
//                            SwiftUIViewWebView(url: url)
//                        } label: {
//                            ZStack {
//                                Circle()
//                                    .foregroundColor(Colors.orange.swiftUIColor)
//                                .frame(width: bounts.width * 0.14)
//
//                                Asset.message.swiftUIImage
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: bounts.width * 0.07)
//                            }
//                            .padding(.trailing, 27)
//                            .padding(.bottom, 20)
//                        }
//                    }
//                }
            }
            .navigationBarTitle("Pomoc i FAQ", displayMode: .inline)
            .navigationBarTitleTextColor(.white)
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
