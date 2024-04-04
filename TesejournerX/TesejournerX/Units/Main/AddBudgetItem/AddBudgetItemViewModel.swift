//
//  AddBudgetItemViewModel.swift
//  TesejournerX
//
//  Created by Andrii Momot on 03.04.2024.
//

import Foundation

extension AddBudgetItemView {
    final class AddBudgetItemViewModel: ObservableObject {
        @Published var topTabBarSelectedIndex = 0
        @Published var isFavorite = false
        @Published var dateText = Date().toString()
        @Published var sumText = ""
        @Published var categoryText = ""
        @Published var noteText = ""
        @Published var selectedCategory: Category?
        @Published var showDatePicker = false
        @Published var showCategories = false
        
        @Published var itemToEditID: String?
        @Published var showNextButton = true
        
        let topTabBarItems = ["Dochód", "Koszty"]
        
        func cleanFields() {
            dateText = Date().toString()
            sumText = ""
            categoryText = ""
            noteText = ""
            selectedCategory = nil
        }
        
        func saveItem() -> Bool {
            if validateFields() {
                guard let savedUser = getUserData() else { return false }
                var newUser = savedUser
                
                let category = getAllCategories().first(where: {
                    $0.name == categoryText
                }) ?? StaticFiles.Categories.inne
                
                let item = UserModel.BudgetItem(
                    isFavorite: self.isFavorite,
                    type: .init(rawValue: topTabBarSelectedIndex) ?? .cost,
                    date: dateText.toDateWith(format: .ddMMyy) ?? Date(),
                    sum: Double(sumText) ?? .zero,
                    category: category,
                    note: noteText
                )
                
                newUser.budgetItems.append(item)
                
                do {
                    try UserDefaultsService.saveUser(model: newUser)
                    return true
                } catch {
                    print(error.localizedDescription)
                    return false
                }
            } else {
                return false
            }
        }
        
        func editItem() -> Bool {
            guard let id = itemToEditID, var user = getUserData() else { return false }
            
            let category = getAllCategories().first(where: {
                $0.name == categoryText
            }) ?? StaticFiles.Categories.inne
            
            if validateFields() {
                let item = UserModel.BudgetItem(
                    isFavorite: self.isFavorite,
                    type: .init(rawValue: topTabBarSelectedIndex) ?? .cost,
                    date: dateText.toDateWith(format: .ddMMyy) ?? Date(),
                    sum: Double(sumText) ?? .zero,
                    category: category,
                    note: noteText
                )
                
                if let index = user.budgetItems.firstIndex(where: {$0.id == id}) {
                    user.budgetItems[index] = item
                    
                    do {
                        try UserDefaultsService.saveUser(model: user)
                        return true
                    } catch {
                        print(error.localizedDescription)
                        return false
                    }
                    
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        
        func validateFields() -> Bool {
            let isValidDate = dateText.toDateWith(format: .ddMMyy) != nil
            dropPointInSumIfItLastChar()
            
            if sumText.last == "." {
                sumText.removeLast()
            }
            
            let isValidSum = Double(sumText) != nil && (Double(sumText) ?? .zero > .zero)
            var isValidCategory = !categoryText.isEmpty
            if !getAllCategories().contains(where: {$0.name == categoryText}) {
                isValidCategory = false
                categoryText = ""
            }
            let isValidNote = !noteText.isEmpty

            return isValidDate && isValidSum && isValidCategory && isValidNote
        }
        
        func dropPointInSumIfItLastChar() {
            if sumText.hasSuffix(".") || sumText.hasSuffix(".") {
                sumText = String(sumText.dropLast())
            }
        }
        
        func getUserData() -> UserModel? {
            return try? UserDefaultsService.getUser()
        }
        
        func getAllCategories() -> [Category]  {
            let personalItems = UserDefaultsService.getPersonalCategories()
            return StaticFiles.Categories.all + personalItems
        }
        
        func getItemToEditWith(id: String) -> UserModel.BudgetItem? {
            guard let items = self.getUserData()?.budgetItems else { return nil }
            return items.first(where: { $0.id == id })
        }
        
        func autofillFieldsWithitem(id: String?) {
            itemToEditID = id
            guard let id = itemToEditID, let item = getItemToEditWith(id: id) else { return }
            topTabBarSelectedIndex = item.type.rawValue
            isFavorite = item.isFavorite
            dateText = item.date.toString()
            sumText = "\(item.sum)"
            categoryText = item.category.name
            noteText = item.note
            
            showNextButton = false
        }
    }
}
