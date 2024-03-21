//
//  LoadingView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 21.03.2024.
//

import SwiftUI

struct LoadingView: View {
    @State private var progress: CGFloat = 0.0
    @State private var progressColors: [Color] = []
    @State private var showNext = false
    
    private var percent: Int {
        return Int(progress * 100)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 0) {
                    Spacer()

                    HStack {
                        Spacer()
                        Image(Asset.logoObject.name)
                            .resizable()
                            .scaledToFit()
                        .frame(width: geometry.size.width * 0.165)
                        Spacer()
                    }

                    Text("Ładowanie...")
                        .foregroundColor(Colors.orange.swiftUIColor)
                        .font(Fonts.LexendDeca.bold.swiftUIFont(size: 24))
                        .padding(.top, 17)

                    ZStack {
                        Capsule(style: .continuous)
                            .frame(
                                width: geometry.size.width * 0.63,
                                height: geometry.size.height * 0.023)

                            .foregroundColor(Colors.liteGray.swiftUIColor)

                        HStack {
                            LinearGradient(
                                gradient: Gradient(colors: progressColors),
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            )
                            .frame(
                                width: (geometry.size.width * 0.63) * progress,
                                height: geometry.size.height * 0.023)
                            .cornerRadius(20)

                            Spacer(minLength: 0)
                        }

                        .frame(
                            width: geometry.size.width * 0.63)
                    }
                    .padding(.top, 17)

                    Text("Jeśli byłbyś tak miły i sprawdził to. (\(percent)%)")
                        .foregroundColor(Colors.middleGray.swiftUIColor)
                        .font(Fonts.LexendDeca.bold.swiftUIFont(fixedSize: 14))
                        .padding(.top, 14)

                    Image(Asset.relaxWithCoffe.name)
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 60)
                        .padding(.horizontal, 27)
                    Spacer()
                }
                .onAppear {
                    startTimer()
                }
                .onChange(of: progress) { newValue in
                    showNext = newValue >= 1
            }
            }
        }
    }
}

private extension LoadingView {
    func makeProgressCollors() {
        var colors: [Color] = []
        let progressInt = Int(progress * 10)
        for index in 0...progressInt {
            if  index % 2 == 0 {
                colors.append(Colors.orange.swiftUIColor)
            } else {
                colors.append(Colors.orange.swiftUIColor.opacity(0.7))
            }
        }
        withAnimation {
            progressColors = colors
        }
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
            if progress < 1 {
                withAnimation {
                    if progress + 0.1 > 1 {
                        progress = 1
                    } else {
                        progress += 0.1
                    }
                }
                makeProgressCollors()
            } else if progress >= 1 {
                timer.invalidate()
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            .previewLayout(.sizeThatFits)
    }
}
