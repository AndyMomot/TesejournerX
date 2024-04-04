//
//  HelpCell.swift
//  TesejournerX
//
//  Created by Andrii Momot on 04.04.2024.
//

import SwiftUI

struct HelpCell: View {
    var model: HelpView.HelpCellModel
    
    var body: some View {
        HStack(spacing: .zero) {
            Spacer(minLength: .zero)
            VStack(alignment: .leading, spacing: 10) {
                Text(model.title)
                    .foregroundColor(.black)
                    .font(Fonts.LexendDeca.bold.swiftUIFont(size: 16))
                
                Text(model.description)
                    .foregroundColor(Colors.middleGray.swiftUIColor)
                    .font(Fonts.LexendDeca.light.swiftUIFont(size: 16))
                
            }
            .multilineTextAlignment(.leading)
            .padding(.vertical, 28)
            .padding(.horizontal, 15)
            
            Spacer(minLength: .zero)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .white, radius: 2)
    }
}

struct HelpCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Colors.silver.swiftUIColor
            
            HelpCell(model: .init(title: "Jak utworzyć nową kategorię?",
                                  description: "Przejdź do menu w prawym górnym rogu, wybierz opcję 'Konfiguracja kategorii', a następnie kliknij 'Utwórz nową kategorię'."))
            .padding()
        }
    }
}
