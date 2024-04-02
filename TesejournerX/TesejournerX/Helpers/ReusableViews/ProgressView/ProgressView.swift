//
//  ProgressView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 02.04.2024.
//

import SwiftUI

struct ProgressView: View {
    var maxValue: Double
    var currentValue: Double
    private var percent: Double
    
    init(maxValue: Double, currentValue: Double) {
        self.maxValue = maxValue
        self.currentValue = currentValue
        
        if currentValue == .zero || maxValue == .zero {
            percent = .zero
        } else if (currentValue / maxValue) > 1 {
            percent = 1
        } else {
            percent = (currentValue / maxValue)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 7) {
                ZStack {
                    // Track
                    Rectangle()
                        .foregroundColor(Colors.silver.swiftUIColor)
                        .frame(height: 25)
                        .cornerRadius(6)
                    
                    HStack {
                        let width = max(0, min(geometry.size.width * percent, geometry.size.width))
                        Rectangle()
                            .foregroundColor(Colors.blueViolet.swiftUIColor)
                            .frame(
                                width: width,
                                height: 25
                            )
                            .cornerRadius(
                                6,
                                corners: percent == 1 ? [.allCorners] : [.topLeft, .bottomLeft]
                            )
                        
                        Spacer(minLength: .zero)
                    }
                    
                    HStack {
                        Spacer(minLength: .zero)
                        
                        var number: String {
                            if percent == .zero {
                                return "0"
                            } else {
                                return (percent * 100.0).string()
                            }
                        }
                        Text("\(number)%")
                            .foregroundColor(.black)
                            .font(Fonts.LexendDeca.light.swiftUIFont(size: 12))
                            .padding(.trailing, 10)
                    }
                }
                
                HStack(alignment: .center, spacing: .zero) {
                    Text("\(currentValue.string())")
                    Spacer(minLength: .zero)
                    Text("\((maxValue - currentValue).string())")
                }
                .foregroundColor(.black)
                .font(Fonts.LexendDeca.light.swiftUIFont(size: 12))
                .padding(.horizontal, 4)
            }
        }
        .onAppear {
            updatePercent()
        }
    }
}

private extension ProgressView {
    func updatePercent() {
        
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green.opacity(0.3)
            
            ProgressView(maxValue: 2500, currentValue: 600)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
