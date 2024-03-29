//
//  ListOfFinancesForMonthView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 28.03.2024.
//

import SwiftUI

struct ListOfFinancesForMonthView: View {
    var items: [UserModel.BudgetItem]
    
    init(items: [UserModel.BudgetItem]) {
        self.items = items
    }
    
    @ObservedObject var userDataPublisher = UserDataPublisher.shared
    @State private var itemsGroupedByMonth: [[UserModel.BudgetItem]] = []
    
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
                ForEach(Array(itemsGroupedByMonth.enumerated()), id: \.offset) { index, items in
                    Section {
                        MonthTransactionCell(items: items)
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
        }
        .scrollContentBackground(.hidden)
        .onAppear {
            viewDidAppear()
        }
        .onReceive(userDataPublisher.objectDidChange) { _ in
            getUserData()
        }
    }
}

private extension ListOfFinancesForMonthView {
    func viewDidAppear() {
        DispatchQueue.main.async {
            itemsGroupedByMonth = groupItems(with: items)
        }
    }
    
    func groupItems(with items: [UserModel.BudgetItem]) -> [[UserModel.BudgetItem]] {
        // Создание словаря, в котором ключи - это год и месяц, а значения - это массив элементов с этими годом и месяцем
        let groupedByMonth = Dictionary(grouping: items) { item -> String in
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: item.date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM"
            if let date = calendar.date(from: components) {
                return dateFormatter.string(from: date)
            } else {
                return ""
            }
        }

        // Преобразование словаря в массив кортежей (ключ, значение) и сортировка его по дате первого элемента в каждом подмассиве
        let sortedGroupedData = groupedByMonth.sorted { first, second in
            guard let firstDate = first.value.first?.date, let secondDate = second.value.first?.date else {
                return false
            }
            return firstDate < secondDate
        }

        // Преобразование отсортированного массива кортежей обратно в массив массивов DataItem
        return sortedGroupedData.map { $0.value }
    }
    
    func getUserData() {
        DispatchQueue.main.async {
            do {
                var savedUser = try UserDefaultsService.getUser()
                itemsGroupedByMonth = groupItems(with: savedUser.budgetItems)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct ListOfFinancesForMonthView_Previews: PreviewProvider {
    static var previews: some View {
        ListOfFinancesForMonthView(items: [])
    }
}
