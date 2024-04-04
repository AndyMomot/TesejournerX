//
//  SearchBar.swift
//  TesejournerX
//
//  Created by Andrii Momot on 04.04.2024.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            Color.clear
            
            HStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(Colors.liteGray.swiftUIColor)
                        .cornerRadius(5)
                    
                    TextField("Szukaj", text: $searchText)
                        .font(Fonts.LexendDeca.light.swiftUIFont(size: 18))
                        .background(Colors.liteGray.swiftUIColor)
                        .padding(.leading, 5)
                }
                .cornerRadius(5)
                .padding(.leading)
                
                Spacer(minLength: 8)
                
                Button("Anulować") {
                    searchText = ""
                    onCancel()
                }
                .foregroundColor(.accentColor)
                .padding(.trailing)
            }
        }
    }
}


struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant("123")) {}
            .frame(height: 30)
    }
}
