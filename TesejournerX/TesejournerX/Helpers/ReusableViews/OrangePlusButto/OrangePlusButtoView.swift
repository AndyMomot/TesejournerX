//
//  OrangePlusButtoView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 24.03.2024.
//

import SwiftUI

struct OrangePlusButtoView: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .font(Fonts.LexendDeca.semiBold.swiftUIFont(size: 20))
                .padding(18)
                .background {
                    Circle()
                        .foregroundColor(Colors.orange.swiftUIColor)
                }
        }

    }
}

struct OrangePlusButtoView_Previews: PreviewProvider {
    static var previews: some View {
        OrangePlusButtoView {}
            .previewLayout(.fixed(width: 61, height: 61))
    }
}
