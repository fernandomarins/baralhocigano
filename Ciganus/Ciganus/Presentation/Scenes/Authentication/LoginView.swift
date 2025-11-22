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
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

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
                        .foregroundColor(.white)
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
                .foregroundColor(.white)
                .padding(.top)

                // Criar conta
                Button("Criar conta") {
                    coordinator.push(.register)
                }
                .foregroundColor(.white)
                .padding(.top)
            }
            .padding()
        }
        // onAppear e onChange devem ser aplicados à view retornada dentro do body,
        // não fora da struct — por isso estão aqui.
        .onAppear {
            Task {
                await viewModel.checkLoginStatus()
            }
        }
        .onChange(of: viewModel.didLogin) { oldValue, newValue in
            if newValue {
                coordinator.push(.main)
            }
        }
    }
}

#Preview {
    LoginView()
}
