//
//  DateSwitcherView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import SwiftUI

struct DateSwitcherView: View {
    var title: String
    var onLeft: (() -> Void)?
    var onRight: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 8) {
            Button {
                onLeft?()
            } label: {
                Asset.leftArrow.swiftUIImage
            }
            .frame(width: 44, height: 44)
            
            
            Spacer()
            
            Text(title)
                .foregroundColor(.white)
                .font(Fonts.LexendDeca.regular.swiftUIFont(size: 16))
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Spacer()
            
            Button {
                onRight?()
            } label: {
                Asset.leftArrow.swiftUIImage
                    .rotationEffect(.degrees(180))
                    .padding(.bottom, 2)
            }
            .frame(width: 44, height: 44)

        }
        .background(Colors.blue.swiftUIColor)
    }
}

struct DateSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        DateSwitcherView(title: "Luty. 2024 r.")
            .previewLayout(.sizeThatFits)
    }
}
