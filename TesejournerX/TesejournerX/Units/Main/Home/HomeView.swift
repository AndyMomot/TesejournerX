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
    @State private var showDeleteDayItemAlert = false
    
    private var topTabBarItems = ["Dni", "Kalendarz", "Miesiąc", "Szczegóły"]
    @State private var balanceInfoData: [BalanceStatusView.StatusModel] = [
        .init(name: "Dochód", value: .zero),
        .init(name: "Koszty", value: .zero),
        .init(name: "Łącznie", value: .zero)
    ]
    @State private var budgetItems: [User.BudgetItem] = []
    @State private var budgetItem: User.BudgetItem?
    
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
                                
                                switch topTabBarSelectedIndex {
                                case 0:
                                    ScrollView(showsIndicators: false) {
                                        VStack(alignment: .center, spacing: 20) {
                                            ForEach(budgetItems, id: \.id) { item in
                                                DayTransactionCell(item: item)
                                                    .onLongPressGesture(perform: {
                                                        budgetItem = item
                                                        showDeleteDayItemAlert = true
                                                    })
                                                    .padding(.horizontal, 27)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.top, 20)
                                    }
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
            .fullScreenCover(isPresented: $onPlusTapped) {
                AddBudgetItemView() {
                    getUserData()
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
            .onAppear {
                getUserData()
            }
            .navigationBarTitleTextColor(.white)
            .alert(isPresented: $showDeleteDayItemAlert) {
                Alert(
                    title: Text("Alert Title"),
                    message: Text("This is a message."),
                    primaryButton: .destructive(Text("OK"), action: {
                        if let item = budgetItem {
                            dayTransactionLongPressed(item: item)
                        }
                    }),
                    secondaryButton: .cancel()
                )
            }
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
                
                budgetItems = savedUser.budgetItems.filter { $0.date.isToday() }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func dayTransactionLongPressed(item: User.BudgetItem) {
        DispatchQueue.main.async {
            do {
                var user = try UserDefaultsService.getUser()
                user.budgetItems.removeAll(where: {
                    $0.id == item.id
                })
                try UserDefaultsService.saveUser(model: user)
                
                getUserData()
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
