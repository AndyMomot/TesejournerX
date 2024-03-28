//
//  CategoryCell.swift
//  TesejournerX
//
//  Created by Andrii Momot on 26.03.2024.
//

import SwiftUI

struct CategoryCell: View {
    var category: Category
    var onSelect: (Category) -> Void
    var onDelete: () -> Void
    
    @State private var showDeleteItemAlert = false
    
    var body: some View {
        Button {
            onSelect(category)
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
                
                if category.isPersonal {
                    Button {
                        showDeleteItemAlert.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 12)
                            .foregroundColor(.black)
                            .padding(.trailing, 5)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(10)
        }
        .alert("Usuwanie kategorii", isPresented: $showDeleteItemAlert) {
            Button("Usuwać", role: .destructive) {
                deleteCategory()
            }
            Button("Anulować", role: .cancel) { }
        } message: {
            Text("Czy na pewno chcesz usunąć kategorię?")
        }
    }
}

private extension CategoryCell {
    func deleteCategory() {
        do {
            try UserDefaultsService.deletePersonalCategory(category)
            onDelete()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct CategoryCell_Previews: PreviewProvider {
    static var previews: some View {
        
        CategoryCell(category: StaticFiles.Categories.all.first!, onSelect: { _ in
            
        }, onDelete: {
            
        })
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
