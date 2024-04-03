//
//  FavoritesViewModel.swift
//  TesejournerX
//
//  Created by Andrii Momot on 03.04.2024.
//

import Foundation

extension FavoritesView {
    final class FavoritesViewModel: ObservableObject {
        @Published var favoriteItems: [UserModel.BudgetItem] = []
        @Published var onPlusTapped = false
        @Published var budgetItemId: String?
        @Published var onEdit = false
        
        func getItems() {
            DispatchQueue.main.async {
                do {
                    let user = try UserDefaultsService.getUser()
                    self.favoriteItems = user.budgetItems.filter { $0.isFavorite }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        func delete(item: UserModel.BudgetItem, completion: @escaping () -> Void) {
            DispatchQueue.main.async {
                do {
                    var user = try UserDefaultsService.getUser()
                    user.budgetItems.removeAll(where: {
                        $0.id == item.id
                    })
                    try UserDefaultsService.saveUser(model: user)
                } catch {
                    print(error.localizedDescription)
                }
                
                completion()
            }
        }
    }
}
