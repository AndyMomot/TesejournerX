//
//  DatePikerView.swift
//  TesejournerX
//
//  Created by Andrii Momot on 25.03.2024.
//

import SwiftUI

struct DatePikerView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var format: Date.Format = .ddMMyy
    @Binding var dateString: String
    @State private var selectedDate = Date()
    private let today = Date()
    
    var body: some View {
        VStack {
            DatePicker("", selection: $selectedDate, in: ...today, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .onChange(of: selectedDate) { newValue in
                    didSelectDate(newValue)
            }
            
            NextButtonView(text: "Z powrotem", state: .bordered) {
                didSelectDate(today)
            }
            .frame(height: 52)
            .padding()
        }
        .navigationBarBackButtonHidden()
    }
}

private extension DatePikerView {
    func didSelectDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        dateString = formatter.string(from: date)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct DatePikerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePikerView(dateString: .constant("07.03.24"))
    }
}
