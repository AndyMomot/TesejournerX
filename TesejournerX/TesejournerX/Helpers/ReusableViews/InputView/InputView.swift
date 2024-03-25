//
//  InputView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 24.03.2024.
//

import SwiftUI

struct InputView: View {
    var title: String
    @Binding var text: String
    var onTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 13) {
                Text(title)
                    .foregroundColor(Colors.middleGray.swiftUIColor)
                    .font(Fonts.LexendDeca.regular.swiftUIFont(size: 16))
                    .multilineTextAlignment(.leading)
                
                VStack(spacing: 3) {
                    TextField("", text: $text)
                        .foregroundColor(.black)
                        .font(Fonts.LexendDeca.regular.swiftUIFont(size: 16))
                        .padding(.horizontal, 8)
                        .onTapGesture {
                            onTap()
                        }
                    
                    Divider()
                        .frame(height: 1)
                }
            }
            
            Spacer(minLength: .zero)
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(title: "Data", text: .constant("123")) {}
    }
}
