//
//  CategoriesView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 26.03.2024.
//

import SwiftUI

struct CategoriesView: View {
    @Binding var showSelf: Bool
    @Binding var selectedCategory: Category?
    var canDismiss = false
    @Environment(\.presentationMode) var presentationMode
    
    @State private var items = StaticFiles.Categories.all
    @State private var showAddItemAlert = false
    @State private var newCategoryNameText = ""
    
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
                        if canDismiss {
                            self.presentationMode.wrappedValue.dismiss()
                        }
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
                        CategoryCell(
                            category: item,
                            onSelect: { selectedItem in
                                if item.name == "Dodaj" {
                                    showAddItemAlert.toggle()
                                } else {
                                    selectedCategory = selectedItem
                                }
                            }, onDelete: {
                                getPersonalCategories()
                            })
                    }
                }
                .padding()
            }
            .background(Colors.silver.swiftUIColor)
        }
        .alert("Utwórz kategorię", isPresented: $showAddItemAlert) {
            TextField("Nazwa kategorii", text: $newCategoryNameText)
                .textInputAutocapitalization(.never)
            Button("OK", action: saveNewCategory)
            Button("Anulować", role: .cancel) { }
        } message: {
            Text("Proszę wpisać nazwę nowej kategorii.")
        }
        .onAppear {
            getPersonalCategories()
        }
    }
}

private extension CategoriesView {
    func saveNewCategory() {
        DispatchQueue.main.async {
            if !newCategoryNameText.isEmpty {
                do {
                    let item = Category(image: "", name: newCategoryNameText, isPersonal: true)
                    try UserDefaultsService.savePersonalCategory(item)
                    getPersonalCategories()
                    newCategoryNameText = ""
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getPersonalCategories() {
        DispatchQueue.main.async {
            let personalItems = UserDefaultsService.getPersonalCategories()
            items.removeAll()
            items = StaticFiles.Categories.all + personalItems
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(showSelf: .constant(false),
                       selectedCategory: .constant(.init(image: "", name: "")))
    }
}
