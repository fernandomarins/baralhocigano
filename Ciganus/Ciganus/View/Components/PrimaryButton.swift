//
//  PrimaryButton.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text(title)
                        .bold()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppColors.deepSepia)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColors.antiqueGold, lineWidth: 1)
            )
            .foregroundColor(AppColors.antiqueGold)
        }
        .opacity(isDisabled || isLoading ? 0.5 : 1)
        .disabled(isDisabled || isLoading)
    }
}

#Preview {
    ZStack {
        AppBackground()
        VStack {
            PrimaryButton(title: "Entrar", action: {})
            PrimaryButton(title: "Carregando", isLoading: true, action: {})
            PrimaryButton(title: "Desabilitado", isDisabled: true, action: {})
        }
        .padding()
    }
}
