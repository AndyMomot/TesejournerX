//
//  CategoryCell.swift
//  TesejournerX
//
//  Created by Andrii Momot on 26.03.2024.
//

import SwiftUI

struct CategoryCell: View {
    var category: Category
    @Binding var selectedCategory: Category?
    
    var body: some View {
        Button {
            selectedCategory = category
        } label: {
            HStack(alignment: .center, spacing: 15) {
                Spacer(minLength: 0)
                
                if !category.image.isEmpty {
                    Image(category.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 28, height: 28)
                        .cornerRadius(14)
                        .padding(.vertical, 18)
                }
                
                Text(category.name)
                    .font(Fonts.LexendDeca.regular.swiftUIFont(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.vertical, 18)
                
                Spacer(minLength: 0)
            }
            .background(Color.white)
            .cornerRadius(10)
        }
    }
}

struct CategoryCell_Previews: PreviewProvider {
    static var previews: some View {
        
        CategoryCell(category: StaticFiles.Categories.all.first!,
                     selectedCategory: .constant(.init(image: "", name: "")))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
