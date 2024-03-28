//
//  MonthTransactionCell.swift
//  TesejournerX
//
//  Created by Andrii Momot on 28.03.2024.
//

import SwiftUI

struct MonthTransactionCell: View {
    var items: [UserModel.BudgetItem]
    
    @State private var income: Double = 0
    @State private var costs: Double = 0
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 15) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Luty")
                        .foregroundColor(.black)
                        .font(Fonts.LexendDeca.regular.swiftUIFont(size: 12))
                    
                    Text("01.02 - 28.02")
                        .foregroundColor(.black)
                        .font(Fonts.LexendDeca.regular.swiftUIFont(size: 12))
                }
                .padding(.leading, 13)
                
                Divider()
                    .background(Colors.divider.swiftUIColor)
                    .frame(width: 2, height: 45)
                    .padding(.vertical, 10)
                    
                VStack(alignment: .leading, spacing: 5) {
                    Text("Wydane")
                        .foregroundColor(Colors.orange.swiftUIColor)
                    
                    Text("Dochód.")
                        .foregroundColor(Colors.blue.swiftUIColor)
                }
                .font(Fonts.LexendDeca.regular.swiftUIFont(size: 14))
                .multilineTextAlignment(.leading)
                
                Spacer(minLength: .zero)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Zł " + costs.string())
                        .foregroundColor(Colors.orange.swiftUIColor)
                    
                    Text("Zł " + income.string())
                        .foregroundColor(Colors.blue.swiftUIColor)
                }
                .font(Fonts.LexendDeca.bold.swiftUIFont(size: 14))
                .multilineTextAlignment(.leading)
                .padding(.trailing, 13)
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 1, x: 1, y: 1)
        .onAppear {
            viewDidAppere()
        }
    }
}

private extension MonthTransactionCell {
    func viewDidAppere() {
        income = items.filter {$0.type == .income}.reduce(0) {$0 + $1.sum}
        costs = items.filter {$0.type == .cost}.reduce(0) {$0 + $1.sum}
    }
}

struct MonthTransactionCell_Previews: PreviewProvider {
    static var previews: some View {
        MonthTransactionCell(items: [])
            .previewLayout(.sizeThatFits)
    }
}
