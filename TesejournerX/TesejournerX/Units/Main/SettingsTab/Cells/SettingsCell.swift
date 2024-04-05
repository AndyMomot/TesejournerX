//
//  SettingsCell.swift
//  TesejournerX
//
//  Created by Andrii Momot on 05.04.2024.
//

import SwiftUI

struct SettingsCell: View {
    var type: CellType
    
    var body: some View {
        HStack(spacing: 20) {
            Image(type.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            
            Text(type.text)
                .foregroundColor(.black)
                .font(Fonts.LexendDeca.regular.swiftUIFont(size: 16))
            
            Spacer(minLength: .zero)
        }
    }
}

struct SettingsCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCell(type: .budgetSettings)
    }
}
