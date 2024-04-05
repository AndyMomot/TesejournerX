//
//  BudgetView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 04.04.2024.
//

import SwiftUI

struct BudgetView: View {
    
    @StateObject private var viewModel = BudgetViewModel()
    @ObservedObject var userDataPublisher = UserDataPublisher.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Colors.blue.swiftUIColor
                    .ignoresSafeArea()
                Asset.homeBg.swiftUIImage
                    .resizable()
                    .ignoresSafeArea(edges: .bottom)
                
                VStack(spacing: .zero) {
                    DateSwitcherView(title: viewModel.getTopTabBarTitle()) {
                        viewModel.onDateSwithcerTapped(onLeft: true)
                    } onRight: {
                        viewModel.onDateSwithcerTapped(onLeft: false)
                    }
                    
                    TopTabView(selectedItem: $viewModel.topTabBarSelectedIndex, items: viewModel.topTabBarItems)
                    
                    VStack(spacing: .zero) {
                        
                        if viewModel.isSearchBarVisible {
                            SearchBar(searchText: $viewModel.searchTearm) {
                                withAnimation {
                                    viewModel.isSearchBarVisible.toggle()
                                }
                            }
                            .frame(height: 30)
                            .padding(.top)
                        }
                        
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 20) {
                                VStack(spacing: .zero) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text("Pozostało (\(viewModel.currentMonth))")
                                                .foregroundColor(Colors.middleGray.swiftUIColor)
                                                .font(Fonts.LexendDeca.regular.swiftUIFont(fixedSize: 16))
                                            
                                            Text("Zł \(viewModel.balance.string(maximumFractionDigits: 1))")
                                                .foregroundColor(Color.black)
                                                .font(Fonts.LexendDeca.medium.swiftUIFont(fixedSize: 18))
                                        }
                                        
                                        Spacer(minLength: .zero)
                                    }
                                    .padding(.top, 15)
                                    .padding(.horizontal, 15)
                                    
                                    IncomCostProgresView(title: "Miesiąc budżet",
                                                         sum: viewModel.income,
                                                         maxValue: viewModel.income,
                                                         currentValue: viewModel.cost)
                                    
                                    .padding(.top, 20)
                                    
                                    Button {
                                        viewModel.onSetBudget.toggle()
                                    } label: {
                                        HStack {
                                            Spacer()
                                            Text("Ustalanie budżetu")
                                                .foregroundColor(.white)
                                                .font(Fonts.LexendDeca.regular.swiftUIFont(size: 14))
                                                .padding(.vertical, 9)
                                            Spacer()
                                        }
                                        .background(Colors.orange.swiftUIColor)
                                        .cornerRadius(5)
                                    }
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 15)
                                }
                                .background(Color.white)
                                .cornerRadius(10)
                                
                                ForEach(Array(viewModel.dataSource.enumerated()), id: \.element) { _, items in
                                    let model = viewModel.makeCellModel(with: items)
                                    IncomCostProgresView(imageName: model.imageName,
                                                         title: model.title,
                                                         sum: model.sum,
                                                         maxValue: model.maxValue,
                                                         currentValue: model.currentValue,
                                                         showProgressBottomValues: false)
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.top, 22)
                        .padding(.horizontal, 27)
                    }
                }
            }
            .navigationBarTitle("Budżet", displayMode: .inline)
            .navigationBarTitleTextColor(.white)
            .navigationBarItems(
                leading:
                    Button(action: {
                        withAnimation {
                            viewModel.isSearchBarVisible.toggle()
                        }
                        if !viewModel.isSearchBarVisible {
                            viewModel.searchTearm = ""
                        }
                    }, label: {
                        Image(Asset.search.name)
                    }),
                trailing:
                    HStack(spacing: 20) {
                        Button(action: {
                            viewModel.showFavorites.toggle()
                        }, label: {
                            Image(Asset.star.name)
                        })
                        
                        Button(action: {
                            
                        }, label: {
                            Image(Asset.sortingRight.name)
                        })
                    }
            )
        }
        .onAppear {
            DispatchQueue.main.async {
                viewModel.setData()
            }
        }
        .onChange(of: viewModel.topTabBarSelectedIndex) { index in
            viewModel.setCurrentTabBarItem(index: index)
        }
        .onChange(of: viewModel.searchTearm) { _ in
            viewModel.makeDataSource()
        }
        .fullScreenCover(isPresented: $viewModel.onSetBudget) {
            AddBudgetItemView()
        }
        .fullScreenCover(isPresented: $viewModel.showFavorites) {
            FavoritesView()
        }
        .onReceive(userDataPublisher.objectDidChange) { _ in
            DispatchQueue.main.async {
                viewModel.setData()
            }
        }
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView()
    }
}
