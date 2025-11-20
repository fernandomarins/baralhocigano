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
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(AppColors.fieldBackground)
            }
        )
        .foregroundColor(AppColors.textPrimary)
        .cornerRadius(8)
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
