//
//  CustomCalendarView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 01.04.2024.
//

import SwiftUI

struct CustomCalendarView: View {
    var date: Date
    
    let columns: [String] = ["Pon", "Wt", "Śr", "Czw", "Pt", "Sob", "Niedz"].map {
        $0.uppercased()
    }
    
    let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "pl_PL")
        calendar.firstWeekday = 2 // Понедельник
        return calendar
    }()
    let numberOfRows = 5
    let daysInWeek = 7
    
    @State private var itemsGroupedByDay: [[UserModel.BudgetItem]] = []
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            // Header с названиями дней недели
            HStack(alignment: .center, spacing: .zero) {
                ForEach(columns.indices, id: \.self) { index in
                    let column = columns[index]
                    Spacer(minLength: .zero)
                    
                    if index == 5 || index == 6 {
                        Text(column)
                            .font(Fonts.LexendDeca.regular.swiftUIFont(size: 12))
                            .background(Color.clear)
                            .foregroundColor(Colors.liteBlue.swiftUIColor)
                    } else {
                        Text(column)
                            .font(Fonts.LexendDeca.regular.swiftUIFont(size: 12))
                            .background(Color.clear)
                            .foregroundColor(Colors.gray.swiftUIColor)
                    }
                    Spacer(minLength: .zero)
                }
            }
            
            // Тело календаря
            VStack(alignment: .leading, spacing: 0) {
                ForEach(0..<numberOfRows, id: \.self) { row in
                    Divider()
                        .frame(width: 0.5)
                        .background {
                            Colors.middleGray.swiftUIColor.opacity(0.8)
                        }
                    
                    HStack(alignment: .center, spacing: .zero) {
                        ForEach(0..<self.daysInWeek, id: \.self) { column in
                            if let date = dayOfMonthForTest(row: row, column: column).0 {
                                let state = dayOfMonthForTest(row: row, column: column).1
                                let model = createDayModel(for: date, state: state)
                                DayOfMonthCell(model: model)
                            }
                            
                            Divider()
                                .frame(width: 0.5)
                                .background {
                                    Colors.middleGray.swiftUIColor.opacity(0.8)
                                }
        
                        }
                    }
                    .border(
                        Colors.middleGray.swiftUIColor.opacity(0.8),
                        width: 0.5
                    )
                }
                
                Divider()
            }
        }
        .onAppear {
            let user = try? UserDefaultsService.getUser()
            itemsGroupedByDay = user?.getGroupedBudgetItemsBy([.day, .month, .year], with: .ddMMyy) ?? []
        }
    }
}

private extension CustomCalendarView {
    // Функция для получения дня месяца для заданного ряда и столбца в календаре
    func dayOfMonthForTest(row: Int, column: Int) -> (Date?, DayOfMonthModel.State) {
        
        // Получаем первый день месяца
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        
        // Определяем день недели для первого дня месяца
        let firstWeekdayOfMonth = calendar.component(.weekday, from: firstDayOfMonth)
        
        // Определяем количество дней в предыдущем месяце
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
        let daysInPreviousMonth = calendar.range(of: .day, in: .month, for: previousMonth)!.count
        
        // Определяем количество дней в текущем месяце
        let daysInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!.count
        
        // Вычисляем порядковый номер дня для текущей ячейки
        let day = (row * daysInWeek) + column - firstWeekdayOfMonth + 3
        
        // Проверяем, принадлежит ли день месяцу, если да, то возвращаем его номер, если нет, то возвращаем номер дня предыдущего или следующего месяца
        if day >= 1 && day <= daysInMonth {
            let dateString = "\(day)." + date.toString(format: .mmYY)
            let date = dateString.toDateWith(format: .ddMMyy)
            
            let isToday = date?.isToday() ?? false
            let isWeekend = date?.isWeekend() ?? false
            
            var itemState: DayOfMonthModel.State = .today
            if isToday {
                itemState = .today
            } else if isWeekend {
                itemState = .weekend
            } else {
                itemState = .weekDay
            }
            
            return (date, itemState)
        } else if day <= 0 {
            // outOfMonth
            let previousMonth = date.addOrSubtract(component: .month, value: -1)
            let dateString = "\(daysInPreviousMonth + day)." + previousMonth.toString(format: .mmYY)
            let itemState: DayOfMonthModel.State = .outOfMonth
            let date = dateString.toDateWith(format: .ddMMyy)
            return (date, itemState)
        } else {
            // outOfMonth
            let nextMonth = date.addOrSubtract(component: .month, value: 1)
            let dateString = "\(day - daysInMonth)." + nextMonth.toString(format: .mmYY)
            let itemState: DayOfMonthModel.State = .outOfMonth
            let date = dateString.toDateWith(format: .ddMMyy)
            return (date, itemState)
        }
    }
    
    func dateFor(day: Int) -> Date {
        let dateString = "\(day)." + date.toString(format: .mmYY)
        return dateString.toDateWith(format: .ddMMyy) ?? date
    }
    
    func createDayModel(for date: Date, state: DayOfMonthModel.State) -> DayOfMonthModel {
        let day = date.getCalendarComponet(period: .day)
        var income: Double = 0
        var cost: Double = 0
        
        if let index = itemsGroupedByDay.firstIndex(where: { array in
            array.contains { item in
                item.date == date
            }
        }) {
            let row = itemsGroupedByDay[index]
            income = row.filter {$0.type == .income}.reduce(0) {$0 + $1.sum}
            cost = row.filter {$0.type == .cost}.reduce(0) {$0 + $1.sum}
        }
        
        return .init(state: state, day: "\(day)", income: income, cost: cost)
    }
}

struct CustomCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCalendarView(date: .init())
    }
}
