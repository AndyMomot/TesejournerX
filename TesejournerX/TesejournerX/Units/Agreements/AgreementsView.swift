//
//  AgreementsView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import SwiftUI

struct AgreementsView: View {
    private var bounts = UIScreen.main.bounds
    
    @EnvironmentObject private var viewModel: AuthViewModel
    
    @State private var onNextTapped = false
    @State private var isAgreed = false
    @State private var checkBoxColor = Color.black
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: bounts.height * 0.09) {
                        
                        Image(Asset.agreenents.name)
                            .resizable()
                            .scaledToFill()
                            .frame(height: bounts.height * 0.32)
                            .padding(.top, bounts.height * 0.16)
                        
                        VStack(spacing: 10) {
                            Text("Welcome to TesejournerX")
                                .foregroundColor(Colors.blue.swiftUIColor)
                                .font(Fonts.LexendDeca.bold.swiftUIFont(size: 24))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                            Text("your intuitive financial diary, simplifying money management for you.")
                                .foregroundColor(.black)
                                .font(Fonts.LexendDeca.regular.swiftUIFont(size: 16))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                        }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 26)
                        
                        VStack(spacing: 30) {
                            NextButtonView(
                                text: "Kontynuuj",
                                state: .filled) {
                                    onNextTapped = true
                                }
                                .frame(height: bounts.height * 0.055)
                            
                            HStack(spacing: 10) {
                                VStack {
                                    ZStack {
                                        Rectangle()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 21)
                                            .cornerRadius(4)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(checkBoxColor, lineWidth: 1)
                                            )
                                            .onTapGesture {
                                                isAgreed.toggle()
                                                highliteCheckBox()
                                            }
                                        
                                        if isAgreed {
                                            Image(systemName: "checkmark", variableValue: 1.00)
                                                .symbolRenderingMode(.monochrome)
                                                .foregroundColor(Colors.orange.swiftUIColor)
                                                .font(.system(size: 16, weight: .bold))
                                        }
                                    }
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Kontynuuj, w pełni akceptuję")
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.leading)
                                        .font(Fonts.LexendDeca.regular.swiftUIFont(size: 14))
                                    
                                    NavigationLink {
                                        let url = URL(string: StaticFiles.Links.offerta)
                                        SwiftUIViewWebView(url: url)
                                    } label: {
                                        Text("Polityka prywatności i Warunki korzystania z usługi.")
                                            .underline()
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(Colors.orange.swiftUIColor)
                                            .font(Fonts.LexendDeca.bold.swiftUIFont(size: 16))
                                            .lineLimit(nil)
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 26)
                    }
                }
            }
            .onDisappear {
                onNextTapped = false
            }
            .onChange(of: onNextTapped, perform: { newValue in
                if newValue && isAgreed {
                    viewModel.signIn()
                } else {
                    highliteCheckBox()
                }
            })
            .onChange(of: isAgreed, perform: { newValue in
                onNextTapped = false
            })
            
            .navigationBarBackButtonHidden()
        }
    }
}

private extension AgreementsView {
    func highliteCheckBox() {
        withAnimation {
            checkBoxColor = isAgreed ? Color.black : Color.red
            if !isAgreed {
                triggerVibration(style: .soft)
                onNextTapped = false
            }
        }
    }
    
    func triggerVibration(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

struct AgreementsView_Previews: PreviewProvider {
    static var previews: some View {
        AgreementsView()
        
        AgreementsView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
    }
}
