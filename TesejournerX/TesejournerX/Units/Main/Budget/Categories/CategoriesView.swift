//
//  CategoriesView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 26.03.2024.
//

import SwiftUI

struct CategoriesView: View {
    @Binding var showSelf: Bool
    
    private let items = StaticFiles.Categories.all
    @Binding var selectedCategory: Category?
    
    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            
            HStack {
                Text("Kategorie")
                    .foregroundColor(.white)
                    .font(Fonts.LexendDeca.regular.swiftUIFont(size: 16))
                    .padding(.leading, 27)
                    .padding(.vertical, 17)
                
                Spacer()
                
                Button {
                    withAnimation {
                        showSelf = false
                    }
                } label: {
                    Asset.crossWhite.swiftUIImage
                }
                .padding(.trailing, 27)
            }
            .background(Colors.blue.swiftUIColor)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(items, id: \.id) { item in
                        CategoryCell(category: item, selectedCategory: $selectedCategory)
                    }
                }
                .padding()
            }
            .background(Colors.silver.swiftUIColor)
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(showSelf: .constant(false),
                       selectedCategory: .constant(.init(image: "", name: "")))
    }
}
