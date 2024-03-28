//
//  DayTransactionCell.swift
//  TesejournerX
//
//  Created by Andrii Momot on 27.03.2024.
//

import SwiftUI

struct DayTransactionCell: View {
    var item: UserModel.BudgetItem
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 15) {
                HStack(alignment: .center, spacing: 5) {
                    if let image = UIImage(named: item.category.image) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .cornerRadius(12)
                    }
                    
                    Text(item.category.name)
                        .foregroundColor(.black)
                        .font(Fonts.LexendDeca.regular.swiftUIFont(size: 12))
                }
                .padding(.leading, 13)
                
                Divider()
                    .background(Colors.divider.swiftUIColor)
                    .frame(width: 2, height: 45)
                    .padding(.vertical, 10)
                    
                VStack(alignment: .leading, spacing: 5) {
                    if !item.note.isEmpty {
                        Text(item.note)
                            .foregroundColor(.black)
                    }
                    
                    Text(item.type.title)
                        .foregroundColor(Colors.middleGray.swiftUIColor)
                }
                .font(Fonts.LexendDeca.regular.swiftUIFont(size: 14))
                .multilineTextAlignment(.leading)
                
                Spacer(minLength: .zero)
                
                Text("Zł " + item.sum.string())
                    .foregroundColor(
                        item.type == .cost ? Colors.orange.swiftUIColor : Colors.blue.swiftUIColor
                    )
                    .font(Fonts.LexendDeca.bold.swiftUIFont(size: 14))
                    .multilineTextAlignment(.center)
                    .padding(.trailing, 13)
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 1, x: 1, y: 1)
    }
}

struct DayTransactionCell_Previews: PreviewProvider {
    static var previews: some View {
        DayTransactionCell(item: .init(
            isFavorite: false,
            type: .income,
            date: Date(),
            sum: 100,
            category: .init(
                image: Asset.yogaCategory.name,
                name: "Joga"),
            note: "Bidryonówka")
        )
        .previewLayout(.sizeThatFits)
    }
}
