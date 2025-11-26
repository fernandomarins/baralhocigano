//
//  CustomTextField.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .never
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(autocapitalization)
                    .disableAutocorrection(true)
            }
        }
        .padding()
        .background(AppColors.fieldBackground)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(AppColors.antiqueGold, lineWidth: 1)
        )
        .foregroundColor(AppColors.textPrimary)
    }
}

#Preview {
    ZStack {
        AppBackground()
        VStack {
            CustomTextField(placeholder: "Email", text: .constant(""))
            CustomTextField(placeholder: "Senha", text: .constant(""), isSecure: true)
        }
        .padding()
    }
}
