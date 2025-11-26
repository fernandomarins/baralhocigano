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
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.2, green: 0.15, blue: 0.3).opacity(0.8),
                        Color(red: 0.15, green: 0.1, blue: 0.25).opacity(0.9)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            colors: [.purple.opacity(0.6), .blue.opacity(0.4), .cyan.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .purple.opacity(0.3), radius: 10)
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
