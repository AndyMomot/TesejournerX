//
//  DetailsView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 02.04.2024.
//

import SwiftUI

struct DetailsView: View {
    var date: Date
    
    init(date: Date) {
        self.date = date
    }
    
    @ObservedObject var userDataPublisher = UserDataPublisher.shared
    
    @State private var costs: Double = .zero
    @State private var budget: Double = .zero
    @State private var income: Double = .zero
    
    @State private var itemsGroupedByMonth: [[UserModel.BudgetItem]] = []
    
    
    private var bounts: CGRect {
        UIScreen.main.bounds
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Konta")
                            .foregroundColor(.black)
                            .font(Fonts.LexendDeca.medium.swiftUIFont(size: 18))
                        Spacer(minLength: 0)
                    }
                    
                    HStack(spacing: .zero) {
                        Text("Wydatki (gotówka, karta)")
                            .font(Fonts.LexendDeca.regular.swiftUIFont(size: 14))
                            .padding(.vertical, 23)
                            .padding(.leading, 16)
                        
                        Spacer(minLength: 0)
                        
                        Text("Zł \(costs.string())")
                            .font(Fonts.LexendDeca.medium.swiftUIFont(size: 14))
                            .padding(.trailing, 16)
                    }
                    .foregroundColor(Colors.middleGray.swiftUIColor)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Budżet")
                            .foregroundColor(.black)
                            .font(Fonts.LexendDeca.medium.swiftUIFont(size: 18))
                        Spacer(minLength: 0)
                    }
                    
                    HStack(spacing: .zero) {
                        VStack(alignment: .leading, spacing: 7) {
                            Text("Całkowity budżet")
                                .font(Fonts.LexendDeca.regular.swiftUIFont(size: 12))

                            Text("Zł \(income.string())")
                                .font(Fonts.LexendDeca.medium.swiftUIFont(size: 12))
                                .foregroundColor(.black)
                        }
                        .padding(.leading, 14)

                        Spacer(minLength: 30)
                        
                        ProgressView(maxValue: income, currentValue: costs)
                            .frame(width: bounts.width * 0.49,
                                   height: bounts.height * 0.052)
                            .padding(.vertical, 30)
                            .padding(.trailing, 15)
                            
                    }
                    .foregroundColor(Colors.middleGray.swiftUIColor)
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding(.horizontal, 27)
        .onAppear {
            setValues(with: date)
        }
        .onReceive(userDataPublisher.objectDidChange) { _ in
            setValues(with: date)
        }
        .onChange(of: date) { newValue in
            setValues(with: newValue)
        }
    }
}

private extension DetailsView {
    func setValues(with date: Date) {
        DispatchQueue.main.async {
            let user = try? UserDefaultsService.getUser()
            let items = user?.budgetItems.filter({
                return $0.date.isYearEqual(to: date)
            }) ?? []
            
            income = items.filter {$0.type == .income}.reduce(0) {$0 + $1.sum}
            costs = items.filter {$0.type == .cost}.reduce(0) {$0 + $1.sum}
            budget = income - costs
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green.opacity(0.3)
            
            DetailsView(date: .init())
        }
    }
}
