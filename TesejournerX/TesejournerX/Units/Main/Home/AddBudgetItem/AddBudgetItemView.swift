//
//  AddBudgetItemView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 24.03.2024.
//

import SwiftUI

struct AddBudgetItemView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var topTabBarSelectedIndex = 0
    @State private var dateText = Date().todayString()
    @State private var sumText = "0.0"
    @State private var categoryText = ""
    @State private var noteText = ""
    
    @State private var showDatePicker = false
    
    private var topTabBarItems = ["Dochód", "Koszty"]
    private var bounts = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            Colors.blue.swiftUIColor
                .ignoresSafeArea(edges: .top)
            
            VStack(spacing: 0) {
                TopTabView(selectedItem: $topTabBarSelectedIndex, items: topTabBarItems)
                
                Rectangle()
                    .foregroundColor(Colors.silver.swiftUIColor)
                    .frame(height: 37)
                    .padding(.top, 19)
                
                VStack {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 50) {
                            VStack(spacing: 15) {
                                
                                // Date
                                InputView(title: "Data", text: $dateText) {
                                    showDatePicker = true
                                }
                                .navigationDestination(
                                    isPresented: $showDatePicker) {
                                        DatePikerView(dateString: $dateText)
                                    }
                        
                                // Sum
                                InputView(title: "Kwota", text: $sumText) {}
                                    .keyboardType(.decimalPad)
                                
                                InputView(title: "Kategoria", text: $categoryText) {}
                                
                                InputView(title: "Notatka", text: $noteText) {}
                            }
                            
                            VStack(alignment: .center, spacing: 20) {
                                NextButtonView(text: "Zapisz", state: .filled) {
                                    
                                }
                                .frame(height: bounts.height * 0.0557)
                                
                                NextButtonView(text: "Zapisz", state: .bordered) {
                                    
                                }
                                .frame(height: bounts.height * 0.0557)
                            }
                            
                            Spacer(minLength: .zero)
                        }
                        .padding(.top, 31)
                    .padding(.horizontal, 26)
                    }
                    
                    Spacer(minLength: 0)
                }
                .frame(width: bounts.width)
                .background(Color.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .padding(.top, -19)
            }
        }
        .navigationBarTitle(topTabBarItems[topTabBarSelectedIndex], displayMode: .inline)
        .navigationBarItems(
            leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(Asset.leftArrow.name)
                })
            ,
            trailing:
                Button(action: {
                    
                }, label: {
                    Image(Asset.star.name)
                })
        )
        .navigationBarTitleTextColor(.white)
        .navigationBarBackButtonHidden()
    }
}

private extension AddBudgetItemView {
    func textFieldTitle(_ text: String) -> some View {
        Text(text)
            .foregroundColor(Colors.middleGray.swiftUIColor)
            .font(Fonts.LexendDeca.regular.swiftUIFont(size: 16))
            .multilineTextAlignment(.leading)

    }
}

struct AddBudgetItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddBudgetItemView()
        }
    }
}
