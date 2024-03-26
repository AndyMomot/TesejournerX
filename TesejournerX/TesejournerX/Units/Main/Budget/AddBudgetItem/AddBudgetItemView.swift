//
//  AddBudgetItemView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 24.03.2024.
//

import SwiftUI

struct AddBudgetItemView: View {
    var onDismiss: () -> Void
    
    init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var topTabBarSelectedIndex = 0
    @State private var dateText = Date().todayString()
    @State private var sumText = ""
    @State private var categoryText = ""
    @State private var noteText = ""
    
    @State var selectedCategory: Category?
    
    @State private var showDatePicker = false
    @State private var showCategories = false
    
    private var topTabBarItems = ["Dochód", "Koszty"]
    private var bounts = UIScreen.main.bounds
    
    var body: some View {
        NavigationStack {
            ZStack {
                Colors.blue.swiftUIColor
                    .ignoresSafeArea(edges: .top)
                
                VStack(spacing: 0) {
                    TopTabView(selectedItem: $topTabBarSelectedIndex, items: topTabBarItems)
                    
                    Rectangle()
                        .foregroundColor(Colors.silver.swiftUIColor)
                        .frame(height: 37)
                        .padding(.top, 19)
                    
                    VStack {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 50) {
                                VStack(spacing: 15) {
                                    
                                    // Date
                                    InputView(title: "Data", text: $dateText) {
                                        withAnimation {
                                            showDatePicker = true
                                        }
                                    }
                                    .navigationDestination(isPresented: $showDatePicker) {
                                        DatePikerView(dateString: $dateText)
                                    }
                                    
                                    // Sum
                                    InputView(title: "Kwota", placeholder: "0.0", text: $sumText) {}
                                        .keyboardType(.numberPad)
                                    
                                    
                                    InputView(title: "Kategoria", text: $categoryText) {
                                        hideKeyboard()
                                        withAnimation {
                                            showCategories = true
                                        }
                                    }
                                    
                                    InputView(title: "Notatka", text: $noteText) {}
                                }
                                
                                VStack(alignment: .center, spacing: 20) {
                                    NextButtonView(text: "Zapisz", state: .filled) {
                                        onSaveAndReturn()
                                    }
                                    .frame(height: 52)
                                    
                                    NextButtonView(text: "Zapisz", state: .bordered) {
                                        onSaveAndCleanFields()
                                    }
                                    .frame(height: 52)
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
                }
            }
            .overlay(
                ZStack {
                    if showCategories {
                        VStack {
                            Spacer()
                            CategoriesView(showSelf: $showCategories,
                                           selectedCategory: $selectedCategory)
                            .frame(height: bounts.height * 0.6)
                        }
                    }
                }
                    .opacity(showCategories ? 1 : 0)
            )
            .onChange(of: selectedCategory) { newValue in
                withAnimation {
                    categoryText = newValue?.name ?? ""
                    showCategories = false
                }
            }
            .onChange(of: sumText) { newValue in
                sumTextDidChange(newValue)
            }
            .navigationBarTitle(topTabBarItems[topTabBarSelectedIndex], displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        onDismiss()
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(Asset.leftArrow.name)
                    })
                ,
                trailing:
                    Button(action: {
                        
                    }, label: {
                        Image(Asset.star.name)
                    })
            )
            .navigationBarTitleTextColor(.white)
            .navigationBarBackButtonHidden()
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
            
            dropPointInSumIfItLastChar()
        }
    }
    
    func sumTextDidChange(_ text: String) {
        var formattedString = ""
        // Разбиваем строку по точке и получаем массив подстрок
        var components = text.components(separatedBy: ".")
        if components.count >= 2 {
            // Берем первую подстроку как целую часть числа
            if let integerPart = Int(components[0]) {
                // Берем вторую подстроку и обрезаем ее до двух символов
                let decimalPart = components[1].prefix(2)
                // Формируем строку с округленной десятичной частью
                formattedString = "\(integerPart).\(decimalPart)"
            }
            
            sumText = formattedString
        }
    }
    
    func onSaveAndReturn() {
        if saveItem() {
            onDismiss()
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func onSaveAndCleanFields() {
        if saveItem() {
            dateText = Date().todayString()
            sumText = ""
            categoryText = ""
            noteText = ""
        }
    }
    
    func saveItem() -> Bool {
        if validateFields() {
            guard let savedUser = getUserData() else { return false }
            var newUser = savedUser
            
            let category = StaticFiles.Categories.all.first(where: {
                $0.name == categoryText
            }) ?? StaticFiles.Categories.inne
            
            let item = User.BudgetItem(
                date: dateText,
                sum: Double(sumText) ?? .zero,
                category: category,
                note: noteText
            )
            
            if topTabBarSelectedIndex == 0 { // Income
                newUser.incomeItems.append(item)
            } else { // Costs
                newUser.costsItems.append(item)
            }
            
            do {
                try UserDefaultsService.saveUser(model: newUser)
                return true
            } catch {
                triggerVibration(style: .medium)
                print(error.localizedDescription)
                return false
            }
        } else {
            triggerVibration(style: .medium)
            return false
        }
    }
    
    func validateFields() -> Bool {
        let isValidDate = dateText.toDateWith(format: .ddMMyy) != nil
        dropPointInSumIfItLastChar()
        let isValidSum = Double(sumText) != nil
        let isValidCategory = !categoryText.isEmpty

        return isValidDate && isValidSum && isValidCategory
    }
    
    func dropPointInSumIfItLastChar() {
        if sumText.hasSuffix(".") || sumText.hasSuffix(".") {
            sumText = String(sumText.dropLast())
        }
    }
    
    func triggerVibration(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func getUserData() -> User? {
        return try? UserDefaultsService.getUser()
    }
}

struct AddBudgetItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddBudgetItemView() {}
        }
    }
}
