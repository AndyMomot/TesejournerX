//
//  ListOfFinancesForTodayView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 28.03.2024.
//

import SwiftUI

struct ListOfFinancesForTodayView: View {
    var items: [UserModel.BudgetItem]
    
    var onDelete: ((UserModel.BudgetItem) -> Void)?
    var onEdit: ((UserModel.BudgetItem) -> Void)?
    
    var body: some View {
        List {
            
            if items.isEmpty {
                Text("")
                    .foregroundColor(.clear)
                    .frame(height: 0)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
            } else {
                ForEach(items, id: \.id) { item in
                    Section {
                        DayTransactionCell(item: item)
                            .swipeActions {
                                Button("Edytować") {
                                    onEdit?(item)
                                }
                                .tint(.green)
                                
                                Button("Usuwać") {
                                    onDelete?(item)
                                }
                                .tint(.red)
                            }
                    }
                }
                .onDelete(perform: delete)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
            
        }
        .scrollContentBackground(.hidden)
    }
}

private extension ListOfFinancesForTodayView {
    func delete(indexSet: IndexSet) {
        DispatchQueue.main.async {
            if let index = indexSet.first {
                let itemToDelete = items[index]
                
                do {
                    var user = try UserDefaultsService.getUser()
                    user.budgetItems.removeAll(where: {
                        $0.id == itemToDelete.id
                    })
                    try UserDefaultsService.saveUser(model: user)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ListOfFinancesForTodayView_Previews: PreviewProvider {
    static var previews: some View {
        ListOfFinancesForTodayView(items: [
            .init(isFavorite: false,
                  type: .income,
                  date: .init(),
                  sum: 100,
                  category: .init(image: Asset.foodCategory.name,
                                  name: "Food"),
                  note: "Coffee"),
            
                .init(isFavorite: false,
                      type: .income,
                      date: .init(),
                      sum: 40,
                      category: .init(image: Asset.yogaCategory.name,
                                      name: "Joga"),
                      note: "Staf")
        ])
    }
}
