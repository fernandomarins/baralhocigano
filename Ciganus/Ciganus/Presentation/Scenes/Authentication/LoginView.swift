//
//  LoginView.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        ZStack {
            CosmicBackground()

            VStack(spacing: 20) {
                Text("Login")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple.opacity(0.9), .blue.opacity(0.9), .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .purple.opacity(0.5), radius: 10)

                // Email field
                CustomTextField(
                    placeholder: "Email",
                    text: $viewModel.email,
                    keyboardType: .emailAddress
                )

                // Password field
                CustomTextField(
                    placeholder: "Senha",
                    text: $viewModel.password,
                    isSecure: true
                )

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red.opacity(0.8))
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }

                // Login button
                PrimaryButton(
                    title: "Entrar",
                    isLoading: viewModel.isLoading,
                    isDisabled: viewModel.email.isEmpty || viewModel.password.isEmpty,
                    action: {
                        Task {
                            await viewModel.login()
                            if viewModel.didLogin {
                                await MainActor.run {
                                    coordinator.push(.main)
                                }
                            }
                        }
                    }
                )

                // Face ID
                Button("Usar Face ID") {
                    Task {
                        if await viewModel.authenticateWithFaceID() {
                            coordinator.push(.main)
                        } else {
                            viewModel.errorMessage = "Falha na autenticação por Face ID."
                        }
                    }
                }
                .foregroundColor(AppColors.textPrimary)
                .padding(.top)

                // Criar conta
                Button("Criar conta") {
                    coordinator.push(.register)
                }
                .foregroundColor(.cyan)
                .padding(.top)
            }
            .padding()
        }
        .onAppear {
            Task {
                await viewModel.checkLoginStatus()
                if viewModel.didLogin {
                    coordinator.push(.main)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
