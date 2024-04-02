//
//  ListOfFinancesForMonthView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 28.03.2024.
//

import SwiftUI

struct ListOfFinancesForMonthView: View {
    var date: Date
    
    init(date: Date) {
        self.date = date
    }
    
    @ObservedObject var userDataPublisher = UserDataPublisher.shared
    @State private var itemsGroupedByMonth: [[UserModel.BudgetItem]] = []
    
    var body: some View {
        List {
            if itemsGroupedByMonth.isEmpty {
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
            getUserData(with: date)
        }
        .onReceive(userDataPublisher.objectDidChange) { _ in
            getUserData(with: date)
        }
        .onChange(of: date) { newValue in
            getUserData(with: newValue)
        }
    }
}

private extension ListOfFinancesForMonthView {
    func groupeBudgetItemsBy(items: [UserModel.BudgetItem],
                             components: Set<Calendar.Component>,
                             with format: Date.Format) -> [[UserModel.BudgetItem]] {
        // Создание словаря, в котором ключи - это components, а значения - это массив элементов с этими components
        let groupedByMonth = Dictionary(grouping: items) { item -> String in
            let calendar = Calendar.current
            let components = calendar.dateComponents(components, from: item.date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format.rawValue
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
    
    func getUserData(with date: Date) {
        itemsGroupedByMonth.removeAll()
        
        DispatchQueue.main.async {
            do {
                let savedUser = try UserDefaultsService.getUser()
                
                let items = savedUser.budgetItems.filter({
                    return $0.date.isYearEqual(to: date)
                })
                
                itemsGroupedByMonth = groupeBudgetItemsBy(items: items, components: [.month, .year], with: .yyyyMM)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct ListOfFinancesForMonthView_Previews: PreviewProvider {
    static var previews: some View {
        ListOfFinancesForMonthView(date: .init())
    }
}
