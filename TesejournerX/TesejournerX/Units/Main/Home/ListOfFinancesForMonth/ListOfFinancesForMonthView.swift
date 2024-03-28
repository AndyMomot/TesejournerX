//
//  ListOfFinancesForMonthView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 28.03.2024.
//

import SwiftUI

struct ListOfFinancesForMonthView: View {
    @State var items: [UserModel.BudgetItem]
    @State private var itemsGroupedByMonth: [[UserModel.BudgetItem]] = []
    
    var body: some View {
        List {
            ForEach(Array(itemsGroupedByMonth.enumerated()), id: \.offset) { index, items in
                Section {
                    MonthTransactionCell(items: items)
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            
        }
        .scrollContentBackground(.hidden)
        .onAppear {
            viewDidAppear()
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
        let groupedData = Dictionary(grouping: items) { item -> String in
            let components = Calendar.current.dateComponents([.year, .month], from: item.date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM"
            return dateFormatter.string(from: components.date ?? Date())
        }

        // Преобразование словаря в массив кортежей (ключ, значение) и сортировка его по дате первого элемента в каждом подмассиве
        let sortedGroupedData = groupedData.sorted { first, second in
            guard let firstDate = first.value.first?.date, let secondDate = second.value.first?.date else {
                return false
            }
            return firstDate < secondDate
        }

        // Преобразование отсортированного массива кортежей обратно в массив массивов DataItem
        return sortedGroupedData.map { $0.value }
    }
}

struct ListOfFinancesForMonthView_Previews: PreviewProvider {
    static var previews: some View {
        ListOfFinancesForMonthView(items: [])
    }
}
