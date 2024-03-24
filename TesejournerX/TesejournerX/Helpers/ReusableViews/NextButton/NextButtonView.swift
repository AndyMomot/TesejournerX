//
//  NextButtonView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import SwiftUI

struct NextButtonView: View {
    var text: String
    var state: ViewState
    var font = Fonts.LexendDeca.bold.swiftUIFont(size: 16)
    @State var cornerRadius: CGFloat = 12
    var onTapped: () -> Void
    
    
    var body: some View {
        Button {
            onTapped()
        } label: {
            switch state {
            case .filled:
                HStack {
                    ZStack {
                        Colors.orange.swiftUIColor
                            .cornerRadius(cornerRadius)
                        
                        Text(text)
                            .foregroundColor(.white)
                            .font(font)
                            .multilineTextAlignment(.center)
                    }
                }
            case .bordered:
                HStack {
                    ZStack {
                        Color.white
                            .cornerRadius(cornerRadius)
                        
                        Text(text)
                            .foregroundColor(Colors.blue.swiftUIColor)
                            .font(font)
                            .multilineTextAlignment(.center)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Colors.borderGray.swiftUIColor, lineWidth: 1)
                    )
                }
            }
        }
    }
}

extension NextButtonView {
    enum ViewState {
        case filled
        case bordered
    }
}

struct NextButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NextButtonView(text: "Kontynuuj ",
                       state: .bordered) {}
        .previewLayout(.fixed(width: 370, height: 52))
    }
}
