//
//  HomeView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var counter = 2024
    @State private var topTabBarSelectedIndex = 0
    
    @State var onPlusTapped = false

    private var topTabBarItems = ["Dni", "Kalendarz", "Miesiąc", "Szczegóły"]
    private var balanceInfoData: [BalanceStatusView.StatusModel] = [
        .init(name: "Dochód", value: 2500),
        .init(name: "Koszty", value: 600),
        .init(name: "Łącznie", value: 1900)
    ]
    
    private var bounts = UIScreen.main.bounds
    
    var body: some View {
        NavigationStack {
            ZStack {
                Colors.blue.swiftUIColor
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    ZStack {
                        Asset.homeBg.swiftUIImage
                            .resizable()
                            .scaledToFill()
                            .offset(.init(width: .zero, height: -bounts.height * 0.14))
                        
                        VStack(spacing: .zero) {
                            DateSwitcherView(title: "\(counter)") {
                                counter -= 1
                                print(counter)
                            } onRight: {
                                counter += 1
                                print(counter)
                            }

                            VStack(spacing: .zero) {
                                TopTabView(selectedItem: $topTabBarSelectedIndex, items: topTabBarItems)
                                BalanceStatusView(data: balanceInfoData)
                            }
                        
                            Spacer()
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        OrangePlusButtoView {
                            onPlusTapped.toggle()
                        }
                        .frame(width: bounts.width * 0.14)
                        .padding(.trailing, 27)
                        .padding(.bottom, 20)
                        .navigationDestination(
                            isPresented: $onPlusTapped) {
                                AddBudgetItemView()
                                Text("")
                                    .hidden()
                            }
                    }
                }
            }
            .navigationBarTitle("Główny", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        
                    }, label: {
                        Image(Asset.search.name)
                    }),
                trailing:
                    HStack(spacing: 20) {
                        Button(action: {
                            
                        }, label: {
                            Image(Asset.star.name)
                        })
                        
                        Button(action: {
                            
                        }, label: {
                            Image(Asset.sortingRight.name)
                        })
                    }
            )
            .navigationBarTitleTextColor(.white)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
    }
}
