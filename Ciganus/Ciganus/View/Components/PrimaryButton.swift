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
            .background(Color.white.opacity(0.3))
            .cornerRadius(10)
            .foregroundColor(.white)
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
