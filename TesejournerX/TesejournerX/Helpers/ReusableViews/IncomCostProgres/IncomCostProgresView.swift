//
//  IncomCostProgresView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 04.04.2024.
//

import SwiftUI

struct IncomCostProgresView: View {
    
    var imageName: String? = nil
    var title: String
    var sum: Double
    var maxValue: Double
    var currentValue: Double
    var showProgressBottomValues = true
    
    private var bounts: CGRect {
        UIScreen.main.bounds
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: .zero) {
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    if let image = UIImage(named: imageName ?? "") {
                        Image(uiImage: image)
                    }
                    
                    Text(title)
                        .font(Fonts.LexendDeca.regular.swiftUIFont(size: 12))
                }

                Text("Zł \(sum.string())")
                    .font(Fonts.LexendDeca.medium.swiftUIFont(size: 12))
                    .foregroundColor(.black)
            }
            .padding(.vertical, 14)
            .padding(.leading, 14)

            Spacer(minLength: 30)
            
            VStack {
                Spacer(minLength: .zero)
                ProgressView(maxValue: maxValue,
                             currentValue: currentValue,
                             showBottomValues: showProgressBottomValues)
                .frame(maxWidth: bounts.width * 0.49)
                Spacer(minLength: .zero)
            }
            .padding(.vertical, 14)
            .padding(.trailing, 14)
                
        }
        .foregroundColor(Colors.middleGray.swiftUIColor)
        .background(Color.white)
    }
}

struct IncomCostProgresView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Colors.silver.swiftUIColor
            IncomCostProgresView(imageName: "foodCategory",
                                 title: "Wynagrodzenie",
                                 sum: 2200,
                                 maxValue: 1600,
                                 currentValue: 600)
                .padding()
        }
    }
}
