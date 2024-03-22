//
//  TopTabView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import SwiftUI

struct TopTabView: View {
    @Binding var selectedItem: Int
    
    var items: [String]
    
    var body: some View {
        HStack {
            Spacer()
            ForEach(Array(items.enumerated()), id: \.element) { index, item in
                VStack {
                    Text(item)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .font(
                            index == selectedItem ? Fonts.LexendDeca.bold.swiftUIFont(size: 16) :
                                Fonts.LexendDeca.light.swiftUIFont(size: 16)
                        )
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(
                            index == selectedItem ? Colors.orange.swiftUIColor :  Color.clear
                        )
                        .cornerRadius(20)
                }
                .onTapGesture {
                    withAnimation(.easeIn(duration: 0.1)) {
                        selectedItem = index
                    }
                }
                Spacer()
            }
        }
        .background(Colors.blue.swiftUIColor )
    }
}

struct TopTabView_Previews: PreviewProvider {
    static var previews: some View {
        TopTabView(selectedItem: .constant(0), items: [
        "Dni", "Kalendarz", "Miesiąc"
        ])
    }
}
