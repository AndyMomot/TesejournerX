//
//  BalanceStatusView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import SwiftUI

struct BalanceStatusView: View {
    
    var data: [StatusModel]
    
    var body: some View {
        VStack(spacing: .zero) {
            Rectangle()
                .foregroundColor(Colors.borderGray.swiftUIColor)
                .frame(height: 2)
            
            HStack {
                Spacer()
                
                ForEach(data, id: \.name) { item in
                    VStack {
                        Text(item.name)
                            .font(Fonts.LexendDeca.light.swiftUIFont(size: 14))
                        Text(item.value.string())
                            .font(Fonts.LexendDeca.medium.swiftUIFont(size: 14))
                            
                    }
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    
                    Spacer()
                }
            }
            .padding(.vertical, 10)
            
            Rectangle()
                .foregroundColor(Colors.borderGray.swiftUIColor)
                .frame(height: 2)
        }
        .background(Color.white)
    }
}

extension BalanceStatusView {
    struct StatusModel {
        var name: String
        var value: Double
    }
}

struct BalanceStatusView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceStatusView(data: [
            .init(name: "Dochód", value: 2500),
            .init(name: "Koszty", value: 600),
            .init(name: "Łącznie", value: 1900)
        ])
        .previewLayout(.sizeThatFits)
    }
}
