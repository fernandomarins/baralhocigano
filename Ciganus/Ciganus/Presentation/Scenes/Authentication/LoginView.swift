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
    @State private var showRegister = false

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 20) {
                Text("Login")
                    .font(AppFonts.title)
                    .foregroundColor(AppColors.textPrimary)

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
                .foregroundColor(AppColors.antiqueGold)
                .padding(.top)
            }
            .padding()
        }
        .onAppear {
            Task {
                await viewModel.checkLoginStatus()
            }
        }
        .onChange(of: viewModel.didLogin) { _, newValue in
            if newValue {
                coordinator.push(.main)
            }
        }
    }
}

#Preview {
    LoginView()
}
