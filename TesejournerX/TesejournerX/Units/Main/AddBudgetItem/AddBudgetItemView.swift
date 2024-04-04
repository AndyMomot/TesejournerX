//
//  AddBudgetItemView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 24.03.2024.
//

import SwiftUI

struct AddBudgetItemView: View {
    var onDimiss: (() -> Void)?
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = AddBudgetItemViewModel()
    private var itemToEditID: String?
    
    private var bounts = UIScreen.main.bounds
    
    init(onDimiss: (() -> Void)? = nil) {
        self.onDimiss = onDimiss
    }
    
    init(editItemID: String, onDimiss: (() -> Void)? = nil) {
        itemToEditID = editItemID
        self.onDimiss = onDimiss
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Colors.blue.swiftUIColor
                    .ignoresSafeArea(edges: .vertical)
                
                VStack(spacing: 0) {
                    TopTabView(selectedItem: $viewModel.topTabBarSelectedIndex,
                               items: viewModel.topTabBarItems)
                    
                    Rectangle()
                        .foregroundColor(Colors.silver.swiftUIColor)
                        .frame(height: 37)
                        .padding(.top, 19)
                    
                    VStack {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 50) {
                                VStack(spacing: 15) {
                                    
                                    // Date
                                    InputView(title: "Data", text: $viewModel.dateText) {
                                        withAnimation {
                                            viewModel.showDatePicker = true
                                        }
                                    }
                                    .navigationDestination(isPresented: $viewModel.showDatePicker) {
                                        DatePikerView(dateString: $viewModel.dateText)
                                    }
                                    
                                    // Sum
                                    InputView(title: "Kwota", placeholder: "0", text: $viewModel.sumText) {}
                                        .keyboardType(.decimalPad)
                                    
                                    
                                    InputView(title: "Kategoria", text: $viewModel.categoryText) {
                                        hideKeyboard()
                                        withAnimation {
                                            viewModel.showCategories = true
                                        }
                                    }
                                    
                                    InputView(title: "Notatka", text: $viewModel.noteText) {}
                                }
                                
                                VStack(alignment: .center, spacing: 20) {
                                    NextButtonView(text: "Zapisz", state: .filled) {
                                        
                                        if viewModel.itemToEditID == nil {
                                            if viewModel.saveItem() {
                                                self.presentationMode.wrappedValue.dismiss()
                                                onDimiss?()
                                            } else {
                                                triggerVibration(style: .medium)
                                            }
                                        } else {
                                            if viewModel.editItem() {
                                                self.presentationMode.wrappedValue.dismiss()
                                                onDimiss?()
                                            } else {
                                                triggerVibration(style: .medium)
                                            }
                                        }
                                    }
                                    .frame(height: 52)
                                    
                                    if viewModel.showNextButton {
                                        NextButtonView(text: "Następny", state: .bordered) {
                                            if viewModel.saveItem() {
                                                viewModel.cleanFields()
                                            } else {
                                                triggerVibration(style: .medium)
                                            }
                                        }
                                        .frame(height: 52)
                                    }
                                }
                                
                                Spacer(minLength: .zero)
                            }
                            .padding(.top, 31)
                            .padding(.horizontal, 26)
                        }
                        
                        Spacer(minLength: 0)
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                    .frame(width: bounts.width)
                    .background(Color.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .padding(.top, -19)
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .overlay(
                ZStack {
                    if viewModel.showCategories {
                        VStack {
                            Spacer()
                            CategoriesView(showSelf: $viewModel.showCategories,
                                           selectedCategory: $viewModel.selectedCategory)
                            .frame(height: bounts.height * 0.6)
                        }
                    }
                }
                    .opacity(viewModel.showCategories ? 1 : 0)
            )
            .onChange(of: viewModel.sumText, perform: { newText in
                let priviewsText = viewModel.sumText.dropLast(1)
                let newChar = String(newText.last ?? Character(""))
                
                if priviewsText.contains(".") && newChar == "." {
                    viewModel.sumText.removeLast()
                }
                
                if newText == "." {
                    viewModel.sumText = "0."
                }
            })
            .onChange(of: viewModel.selectedCategory) { newValue in
                withAnimation {
                    viewModel.categoryText = newValue?.name ?? ""
                    viewModel.showCategories = false
                }
            }
            .navigationBarTitle(viewModel.topTabBarItems[viewModel.topTabBarSelectedIndex],
                                displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        onDimiss?()
                    }, label: {
                        Image(Asset.leftArrow.name)
                    })
                ,
                trailing:
                    Button(action: {
                        viewModel.isFavorite.toggle()
                    }, label: {
                        if viewModel.isFavorite {
                            Image(systemName: "star.fill")
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "star")
                                .foregroundColor(.white)
                        }
                    })
            )
            .navigationBarTitleTextColor(.white)
            .navigationBarBackButtonHidden()
            .onAppear {
                viewModel.autofillFieldsWithitem(id: itemToEditID)
            }
        }
    }
}

private extension AddBudgetItemView {
    func textFieldTitle(_ text: String) -> some View {
        Text(text)
            .foregroundColor(Colors.middleGray.swiftUIColor)
            .font(Fonts.LexendDeca.regular.swiftUIFont(size: 16))
            .multilineTextAlignment(.leading)
    }
    
    func hideKeyboard() {
        DispatchQueue.main.async {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil)
            
            viewModel.dropPointInSumIfItLastChar()
        }
    }
    
    func triggerVibration(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

struct AddBudgetItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddBudgetItemView()
        }
    }
}
