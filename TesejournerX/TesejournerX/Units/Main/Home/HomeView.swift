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
    
    @StateObject private var homeViewModel = HomeViewModel()
    
    @State private var currentDaysDate = Date()
    @State private var currentCalendarDate = Date()
    @State private var currentMonthDate = Date()
    @State private var currentDetailsDate = Date()
    
    @State private var topTabBarSelectedIndex = 0
    @State private var currentTabBarItem = Home.TopTabBarItem.days
    
    @State private var onPlusTapped = false
    @State private var onEdit = false
    @State private var showFavorites = false
    
    private var topTabBarItems = Home.TopTabBarItem.allCases.sorted(by: {$0.rawValue < $1.rawValue}).map {$0.title}
    @State private var balanceInfoData: [BalanceStatusView.StatusModel] = [
        .init(name: "Dochód", value: .zero),
        .init(name: "Koszty", value: .zero),
        .init(name: "Łącznie", value: .zero)
    ]
    
    @State private var budgetItems: [UserModel.BudgetItem] = []
    @State private var budgetItemId: String?
    
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
                            .ignoresSafeArea(edges: .bottom)
                        
                        VStack(spacing: .zero) {
                            DateSwitcherView(title: getTopTabBarTitle()) {
                                onDateSwithcerTapped(onLeft: true)
                            } onRight: {
                                onDateSwithcerTapped(onLeft: false)
                            }

                            VStack(spacing: .zero) {
                                TopTabView(selectedItem: $topTabBarSelectedIndex, items: topTabBarItems)
                                
                                BalanceStatusView(data: balanceInfoData)
                                
                                switch currentTabBarItem {
                                case .days:
                                    let items = budgetItems.filter {
                                        $0.date.isDayEqual(to: currentDaysDate)
                                    }
                                    
                                    ListOfFinancesForTodayView(items: items, onDelete: { item in
                                        homeViewModel.delete(item: item) {
                                            getUserData()
                                        }
                                    }, onEdit: { item in
                                        budgetItemId = item.id
                                        
                                    })
                                    .fullScreenCover(isPresented: $onEdit) {
                                        if let id = budgetItemId {
                                            AddBudgetItemView(editItemID: id) {
                                                budgetItemId = nil
                                            }
                                        }
                                    }
                                    .swipeGesture { direction in
                                        switch direction {
                                        case .left:
                                            onDateSwithcerTapped(onLeft: false)
                                        case .right:
                                            onDateSwithcerTapped(onLeft: true)
                                        }
                                    }
                                case .calendar:
                                    CustomCalendarView(date: currentCalendarDate)
                                        .padding(.top, bounts.height * 0.043)
                                        .padding(.horizontal, 30)
                                        .frame(height: bounts.height * 0.5)
                                        .swipeGesture { direction in
                                            switch direction {
                                            case .left:
                                                onDateSwithcerTapped(onLeft: false)
                                            case .right:
                                                onDateSwithcerTapped(onLeft: true)
                                            }
                                        }
                                case .month:
                                    ListOfFinancesForMonthView(date: currentMonthDate)
                                    .swipeGesture { direction in
                                        switch direction {
                                        case .left:
                                            onDateSwithcerTapped(onLeft: false)
                                        case .right:
                                            onDateSwithcerTapped(onLeft: true)
                                        }
                                    }
                                case .details:
                                    DetailsView(date: currentDetailsDate)
                                        .padding(.top, 30)
                                        .swipeGesture { direction in
                                            switch direction {
                                            case .left:
                                                onDateSwithcerTapped(onLeft: false)
                                            case .right:
                                                onDateSwithcerTapped(onLeft: true)
                                            }
                                        }
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
            .fullScreenCover(isPresented: $showFavorites) {
                FavoritesView()
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
                            showFavorites.toggle()
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
            .onChange(of: topTabBarSelectedIndex) { newValue in
                if let newTabBarItem = Home.TopTabBarItem.init(rawValue: newValue) {
                    currentTabBarItem = newTabBarItem
                }
            }
            .onChange(of: budgetItemId) { newValue in
                if newValue != nil {
                    onEdit.toggle()
                }
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
                
                budgetItems = savedUser.budgetItems
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func onDateSwithcerTapped(onLeft: Bool) {
        let value: Int = onLeft ? -1 : 1
        
        switch currentTabBarItem {
        case .days:
            currentDaysDate = currentDaysDate.addOrSubtract(component: .day, value: value)
        case .calendar:
            currentCalendarDate = currentCalendarDate.addOrSubtract(component: .month, value: value)
        case .month:
            currentMonthDate = currentMonthDate.addOrSubtract(component: .year, value: value)
        case .details:
            currentDetailsDate = currentDetailsDate.addOrSubtract(component: .year, value: value)
        }
    }
    
    func getTopTabBarTitle() -> String {
        switch currentTabBarItem {
        case .days:
            return currentDaysDate.toString(format: .dayMonthNameYear)
        case .calendar:
            return currentCalendarDate.toString(format: .monthNameYear)
        case .month:
            return currentMonthDate.toString(format: .year)
        case .details:
            return currentDetailsDate.toString(format: .year)
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
