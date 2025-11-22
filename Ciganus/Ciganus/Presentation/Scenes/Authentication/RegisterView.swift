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
            AppBackground()
            
            VStack(spacing: 20) {
                Text("Criar Conta")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                
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
                        .foregroundColor(.white)
                        .font(.caption)
                }
                
                PrimaryButton(
                    title: "Registrar",
                    isLoading: viewModel.isLoading,
                    isDisabled: viewModel.email.isEmpty || viewModel.password.isEmpty,
                    action: {
                        Task { await viewModel.register() }
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
