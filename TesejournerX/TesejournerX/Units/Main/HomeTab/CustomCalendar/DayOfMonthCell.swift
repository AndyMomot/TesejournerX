//
//  DayOfMonthCell.swift
//  TesejournerX
//
//  Created by Andrii Momot on 01.04.2024.
//

import SwiftUI

struct DayOfMonthCell: View {
    var model: DayOfMonthModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(model.day)
                    .font(Fonts.LexendDeca.regular.swiftUIFont(size: 14))
                    .foregroundColor(model.foregroundColor)
                    .padding(.top, 8)
                    .padding(.leading, 4)
                    .padding(.bottom, 4)
                Spacer()
            }
            .background(model.state == .today ? Colors.blue.swiftUIColor : .clear)
            
            Spacer(minLength: 0)
            
            VStack(alignment: .leading, spacing: 0) {
                if model.income > 0 {
                    Text(model.income.string())
                        .foregroundColor(Colors.blueViolet.swiftUIColor)
                }
                
                if model.cost > 0 {
                    Text(model.cost.string())
                        .foregroundColor(Colors.orange.swiftUIColor)
                }
            }
            .font(Fonts.LexendDeca.regular.swiftUIFont(size: 12))
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .padding(.horizontal, 3)
            .padding(.bottom, 5)
        }
        .background(
            model.state == .outOfMonth ? Colors.liteGray.swiftUIColor : .white
        )
        
    }
}

struct DayOfMonthCell_Previews: PreviewProvider {
    static var previews: some View {
        DayOfMonthCell(model: .init(state: .outOfMonth,
                                    day: "31",
                                    income: 10000.000,
                                    cost: 50.000))
            .previewLayout(.fixed(width: 53, height: 83))
            
    }
}


struct DayOfMonthModel {
    var state: State
    var day: String
    var income: Double
    var cost: Double
    
    enum State {
        case today
        case weekDay
        case weekend
        case outOfMonth
    }
    
    var foregroundColor: Color {
        switch state {
        case .today:
            return .white
        case .weekDay:
            return Colors.gray.swiftUIColor
        case .weekend:
            return Colors.liteBlue.swiftUIColor
        case .outOfMonth:
            return Colors.middleGray.swiftUIColor.opacity(0.5)
        }
    }
}
