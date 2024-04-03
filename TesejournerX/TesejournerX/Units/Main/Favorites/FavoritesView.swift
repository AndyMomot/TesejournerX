//
//  FavoritesView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 03.04.2024.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Colors.blue.swiftUIColor
                    .ignoresSafeArea()
                
                ZStack {
                    if viewModel.favoriteItems.isEmpty {
                        Colors.silver.swiftUIColor
                            .ignoresSafeArea(edges: .bottom)
                        
                        Asset.emptyFolder.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 106)
                    } else {
                        Asset.homeBg.swiftUIImage
                            .resizable()
                            .ignoresSafeArea(edges: .bottom)
                        
                        ListOfFinancesForTodayView(items: viewModel.favoriteItems) { item in
                            viewModel.delete(item: item) {
                                viewModel.getItems()
                            }
                        } onEdit: { item in
                            viewModel.budgetItemId = item.id
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitle("Ulubione", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(Asset.crossWhite.name)
                    }),
                trailing:
                    Button(action: {
                        viewModel.onPlusTapped.toggle()
                    }, label: {
                        Image(Asset.crossWhite.name)
                            .rotationEffect(.degrees(45))
                    })
            )
            .navigationBarTitleTextColor(.white)
            .onAppear {
                viewModel.getItems()
            }
            .fullScreenCover(isPresented: $viewModel.onPlusTapped) {
                AddBudgetItemView() {
                    viewModel.getItems()
                }
            }
            .fullScreenCover(isPresented: $viewModel.onEdit) {
                if let id = viewModel.budgetItemId {
                    AddBudgetItemView(editItemID: id) {
                        viewModel.budgetItemId = nil
                        viewModel.getItems()
                    }
                }
            }
            .onChange(of: viewModel.budgetItemId) { newValue in
                if newValue != nil {
                    viewModel.onEdit.toggle()
                }
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavoritesView()
        }
    }
}
