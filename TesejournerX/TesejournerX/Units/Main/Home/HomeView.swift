//
//  HomeView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: AuthViewModel
    @ObservedObject var userDataPublisher = UserDataPublisher.shared
    
    
    @State private var currentYear: Int = Date().getCurrent(period: .year)
    @State private var topTabBarSelectedIndex = 0
    
    @State var onPlusTapped = false
    @State private var showDeleteDayItemAlert = false
    
    private var topTabBarItems = ["Dni", "Kalendarz", "Miesiąc", "Szczegóły"]
    @State private var balanceInfoData: [BalanceStatusView.StatusModel] = [
        .init(name: "Dochód", value: .zero),
        .init(name: "Koszty", value: .zero),
        .init(name: "Łącznie", value: .zero)
    ]
    @State private var budgetItems: [UserModel.BudgetItem] = []
    
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
                            DateSwitcherView(title: "\(currentYear)") {
                                currentYear -= 1
                                print(currentYear)
                            } onRight: {
                                currentYear += 1
                                print(currentYear)
                            }

                            VStack(spacing: .zero) {
                                TopTabView(selectedItem: $topTabBarSelectedIndex, items: topTabBarItems)
                                
                                BalanceStatusView(data: balanceInfoData)
                                
                                switch topTabBarSelectedIndex {
                                case 0:
                                    ListOfFinancesForTodayView(items: budgetItems)
                                case 2:
                                    ListOfFinancesForMonthView(items: budgetItems)
                                default:
                                    EmptyView()
                                }
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
                    }
                }
            }
            .onReceive(userDataPublisher.objectDidChange) { _ in
                getUserData()
            }
            .fullScreenCover(isPresented: $onPlusTapped) {
                AddBudgetItemView()
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
            .onAppear {
                getUserData()
            }
            .navigationBarTitleTextColor(.white)
        }
    }
}

private extension HomeView {
    func getUserData() {
        DispatchQueue.main.async {
            do {
                var savedUser = try UserDefaultsService.getUser()
                balanceInfoData = [
                    .init(name: "Dochód", value: savedUser.income),
                    .init(name: "Koszty", value: savedUser.costs),
                    .init(name: "Łącznie", value: savedUser.balance)
                ]
                
                budgetItems = savedUser.budgetItems
                
            } catch {
                print(error.localizedDescription)
            }
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
