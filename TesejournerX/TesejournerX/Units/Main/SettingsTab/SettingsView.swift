//
//  SettingsView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 05.04.2024.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Colors.blue.swiftUIColor
                    .ignoresSafeArea()
                
                Asset.homeBg.swiftUIImage
                    .resizable()
                    .ignoresSafeArea(edges: .bottom)
                
                ScrollView {
                    VStack(spacing: 30) {
                        HStack(spacing: 10) {
                            Asset.profile.swiftUIImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 46, height: 46)
                                .cornerRadius(23)
                                .shadow(color: .black.opacity(0.1), radius: 1)
                            
                            Text("\(viewModel.userName)")
                                .foregroundColor(.black)
                                .font(Fonts.LexendDeca.regular.swiftUIFont(size: 18))
                            
                            Spacer()
                            
                            Button {
                                viewModel.showSetUserNameAlert.toggle()
                            } label: {
                                Asset.editBlack.swiftUIImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 20) {
                            let items = viewModel.dataSource.sorted(by: {
                                $0.rawValue < $1.rawValue
                            })
                            ForEach(items, id: \.rawValue) { type in
                                SettingsCell(type: type)
                                    .onTapGesture {
                                        viewModel.onCellTapped(with: type)
                                    }
                            }
                        }
                    }
                }
                .padding(.horizontal, 27)
                .padding(.top, 20)
                // CategoriesView
                .navigationDestination(
                    isPresented: $viewModel.showCategories) {
                        CategoriesView(showSelf: .constant(false),
                                       selectedCategory: .constant(nil),
                                       canDismiss: true)
                    }
                // Write a review
                    .navigationDestination(
                        isPresented: $viewModel.showWriteReview) {
                            SwiftUIViewWebView(url: viewModel.defaultURL)
                        }
                // Favorite
                        .navigationDestination(
                            isPresented: $viewModel.showUlubion) {
                                FavoritesView()
                            }
                // Calendar
                            .navigationDestination(
                                isPresented: $viewModel.showCalendar) {
                                    CustomCalendarView(date: .init())
                                }
                // BudgetSettings
                                .navigationDestination(
                                    isPresented: $viewModel.showBudgetSettings) {
                                        AddBudgetItemView()
                                    }
                // Help
                                    .navigationDestination(
                                        isPresented: $viewModel.showHelp) {
                                            HelpView()
                                        }
            }
            .navigationBarTitle("Ustawienia", displayMode: .inline)
            .navigationBarTitleTextColor(.white)
            .alert("Ustaw nazwę użytkownika", isPresented: $viewModel.showSetUserNameAlert) {
                TextField("Nazwa kategorii", text: $viewModel.userName)
                    .textInputAutocapitalization(.never)
                Button("OK", action: viewModel.setUserName)
                Button("Anulować", role: .cancel) { }
            } message: {
                Text("Zawsze możesz ustawić inną nazwę użytkownika")
            }
        }
        .onAppear {
            viewModel.getUserData()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
