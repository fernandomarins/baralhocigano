//
//  RegisterView.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            CosmicBackground()
            
            VStack(spacing: 20) {
                Text("Criar Conta")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple.opacity(0.9), .blue.opacity(0.9), .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .purple.opacity(0.5), radius: 10)
                
                CustomTextField(
                    placeholder: "Email",
                    text: $viewModel.email,
                    keyboardType: .emailAddress
                )
                
                CustomTextField(
                    placeholder: "Senha",
                    text: $viewModel.password,
                    isSecure: true
                )
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red.opacity(0.8))
                        .font(.caption)
                }
                
                PrimaryButton(
                    title: "Registrar",
                    isLoading: viewModel.isLoading,
                    isDisabled: viewModel.email.isEmpty || viewModel.password.isEmpty,
                    action: {
                        Task { 
                            await viewModel.register()
                            if viewModel.didRegister {
                                await MainActor.run {
                                    coordinator.push(.main)
                                }
                            }
                        }
                    }
                )
                
                Spacer()
            }
            .padding()
            .padding(.top, 100)
            .onChange(of: viewModel.didRegister) { _, didRegister in
                if didRegister {
                    coordinator.push(.main)
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
