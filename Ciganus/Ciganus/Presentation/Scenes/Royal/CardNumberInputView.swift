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
        isDuplicate ? .red : .white
    }
    
    private var borderWidth: CGFloat {
        isDuplicate ? 2 : 1
    }

    var body: some View {
        TextField("", text: $cardNumber)
            .focused($textFieldFocused)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(.title2.weight(.bold))
            .foregroundColor(.white)
            .padding(4)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
                    .background(Color.white.opacity(0.2).cornerRadius(8))
            )
            .onChange(of: textFieldFocused) { _, newValue in
                onFocusChange(newValue)
            }
            .onChange(of: isFocused) { _, newValue in
                if textFieldFocused != newValue {
                    textFieldFocused = newValue
                }
            }
    }
}

#Preview {
    ZStack {
        Color.purple
        CardNumberInputView(
            cardNumber: .constant("12"),
            isDuplicate: false,
            isFocused: false,
            onFocusChange: { _ in }
        )
        .frame(width: 60, height: 60)
        .padding()
    }
}
