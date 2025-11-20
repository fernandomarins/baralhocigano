//
//  CardNumberInputView.swift
//  Ciganus
//
//  Created by Fernando Marins on 13/04/25.
//

import SwiftUI

struct CardNumberInputView: View {
    @Binding var cardNumber: String
    let isDuplicate: Bool
    let isFocused: Bool
    let onFocusChange: (Bool) -> Void
    @FocusState private var textFieldFocused: Bool

    private var borderColor: Color {
        isDuplicate ? Color.red : Color.blue
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(borderColor, lineWidth: isDuplicate ? 2 : 1)
            .background(Color.clear)
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                TextField("", text: $cardNumber)
                    .focused($textFieldFocused)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(8)
                    .onChange(of: textFieldFocused) { _, newValue in
                        onFocusChange(newValue)
                    }
            )
    }
}

#Preview {
    CardNumberInputView(cardNumber: .constant(""), isDuplicate: false, isFocused: false, onFocusChange: { _ in })
}
