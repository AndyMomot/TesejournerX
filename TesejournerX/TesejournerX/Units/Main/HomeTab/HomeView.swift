//
//  HomeView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var userDataPublisher = UserDataPublisher.shared
    @EnvironmentObject private var viewModel: AuthViewModel
    @EnvironmentObject private var tabBarViewModel: TabBarView.TabBarViewModel
    @StateObject private var homeViewModel = HomeViewModel()
    
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
                            
                            DateSwitcherView(title: homeViewModel.getTopTabBarTitle()) {
                                homeViewModel.onDateSwithcerTapped(onLeft: true)
                            } onRight: {
                                homeViewModel.onDateSwithcerTapped(onLeft: false)
                            }

                            VStack(spacing: .zero) {
                                TopTabView(selectedItem: $homeViewModel.topTabBarSelectedIndex,
                                           items: homeViewModel.topTabBarItems)
                                
                                BalanceStatusView(data: homeViewModel.balanceInfoData)
                                
                                switch homeViewModel.currentTabBarItem {
                                case .days:
                                    
                                    if homeViewModel.isSearchBarVisible {
                                        SearchBar(searchText: $homeViewModel.searchTearm) {
                                            withAnimation {
                                                homeViewModel.isSearchBarVisible.toggle()
                                            }
                                        }
                                        .frame(height: 30)
                                        .padding(.top)
                                    }
                                    var items: [UserModel.BudgetItem] {
                                        if homeViewModel.searchTearm.isEmpty {
                                            return homeViewModel.budgetItems.filter {
                                                $0.date.isDayEqual(to: homeViewModel.currentDaysDate)
                                            }
                                        } else {
                                            return homeViewModel.budgetItems.filter { $0.note.localizedCaseInsensitiveContains(homeViewModel.searchTearm) ||
                                                $0.category.name.localizedCaseInsensitiveContains(homeViewModel.searchTearm)
                                            }
                                        }
                                    }
                                    
                                    ListOfFinancesForTodayView(items: items, onDelete: { item in
                                        homeViewModel.delete(item: item) {
                                            homeViewModel.getUserData()
                                        }
                                    }, onEdit: { item in
                                        homeViewModel.budgetItemId = item.id
                                        
                                    })
                                    .fullScreenCover(isPresented: $homeViewModel.onEdit) {
                                        if let id = homeViewModel.budgetItemId {
                                            AddBudgetItemView(editItemID: id) {
                                                homeViewModel.budgetItemId = nil
                                            }
                                        }
                                    }
                                case .calendar:
                                    CustomCalendarView(date: homeViewModel.currentCalendarDate)
                                        .padding(.top, bounts.height * 0.043)
                                        .padding(.horizontal, 30)
                                        .frame(height: bounts.height * 0.5)
                                        .swipeGesture { direction in
                                            switch direction {
                                            case .left:
                                                homeViewModel.onDateSwithcerTapped(onLeft: false)
                                            case .right:
                                                homeViewModel.onDateSwithcerTapped(onLeft: true)
                                            }
                                        }
                                case .month:
                                    ListOfFinancesForMonthView(date: homeViewModel.currentMonthDate)
                                    .swipeGesture { direction in
                                        switch direction {
                                        case .left:
                                            homeViewModel.onDateSwithcerTapped(onLeft: false)
                                        case .right:
                                            homeViewModel.onDateSwithcerTapped(onLeft: true)
                                        }
                                    }
                                case .details:
                                    DetailsView(date: homeViewModel.currentDetailsDate)
                                        .padding(.top, 30)
                                        .swipeGesture { direction in
                                            switch direction {
                                            case .left:
                                                homeViewModel.onDateSwithcerTapped(onLeft: false)
                                            case .right:
                                                homeViewModel.onDateSwithcerTapped(onLeft: true)
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
                            homeViewModel.onPlusTapped.toggle()
                        }
                        .frame(width: bounts.width * 0.14)
                        .padding(.trailing, 27)
                        .padding(.bottom, 20)
                    }
                }
            }
            .onReceive(userDataPublisher.objectDidChange) { _ in
                homeViewModel.getUserData()
            }
            .fullScreenCover(isPresented: $homeViewModel.onPlusTapped) {
                AddBudgetItemView()
            }
            .fullScreenCover(isPresented: $homeViewModel.showFavorites) {
                FavoritesView()
            }
            .navigationBarTitle("Główny", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        withAnimation {
                            homeViewModel.isSearchBarVisible.toggle()
                        }
                        if !homeViewModel.isSearchBarVisible {
                            homeViewModel.searchTearm = ""
                        }
                    }, label: {
                        if homeViewModel.currentTabBarItem == .days {
                            Image(Asset.search.name)
                        }
                    }),
                trailing:
                    HStack(spacing: 20) {
                        Button(action: {
                            homeViewModel.showFavorites.toggle()
                        }, label: {
                            Image(Asset.star.name)
                        })
                        
                        Button(action: {
                            tabBarViewModel.selection = TabBarView.TabBarSelectionView.settings.rawValue
                        }, label: {
                            Image(Asset.sortingRight.name)
                        })
                    }
            )
            .navigationBarTitleTextColor(.white)
            .onAppear {
                homeViewModel.getUserData()
            }
            .onChange(of: homeViewModel.topTabBarSelectedIndex) { newValue in
                if let newTabBarItem = Home.TopTabBarItem.init(rawValue: newValue) {
                    homeViewModel.currentTabBarItem = newTabBarItem
                }
            }
            .onChange(of: homeViewModel.budgetItemId) { newValue in
                if newValue != nil {
                    homeViewModel.onEdit.toggle()
                }
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
