//
//  CustomTabBarView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedItem: Int
    
    private let height = UIScreen.main.bounds.height * 0.11
    
    private let tabBarItems: [TabBarItem] = [
        .init(image: Asset.homeTab.name,
              selectedImage: Asset.homeTabSelected.name,
              title: "Główny"),
        .init(image: Asset.budgetTab.name,
              selectedImage: Asset.budgetTabSelected.name,
              title: "Budżet"),
        .init(image: Asset.helpTab.name,
              selectedImage: Asset.helpTabSelected.name,
              title: "Pomoc i FAQ"),
        .init(image: Asset.settingsTab.name,
              selectedImage: Asset.settingsTabSelected.name,
              title: "Ustawienia")
    ]
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: height)
                .foregroundColor(Color.white)
            
            HStack(spacing: 0) {
                ForEach(0..<4) { index in
                    let isSelectedItem = index == selectedItem
                    let item = tabBarItems[index]
                    
                    var image: String {
                        if isSelectedItem {
                            return item.selectedImage
                        } else {
                            return item.image
                        }
                    }
                    
                    var color: Color {
                        if isSelectedItem {
                            return Colors.orange.swiftUIColor
                        } else {
                            return Colors.middleGray.swiftUIColor
                        }
                    }
                    
                    Button {
                        if !isSelectedItem {
                            selectedItem = index
                        }
                    } label: {
                        let spacing: CGFloat = index == 0 ? 10 : 7
                        VStack(spacing: spacing) {
                            Image(image)
                        
                            Text(item.title)
                                .font(Fonts.LexendDeca.regular.swiftUIFont(size: 12))
                                .foregroundColor(color)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                            Spacer()
                        }
                        .padding(.top, 15)
                        .padding(.horizontal)
                    }
                }
            }
            .frame(height: height)
        }
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarView(selectedItem: .constant(0))
            .previewLayout(.sizeThatFits)
    }
}

struct TabBarItem {
    var image: String
    var selectedImage: String
    var title: String
}
