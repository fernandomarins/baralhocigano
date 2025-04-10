//
//  RegisterView.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @State private var navigateToMain = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.indigo]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Criar Conta")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    
                    SecureField("Senha", text: $viewModel.password)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: {
                        Task { await viewModel.register() }
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text("Registrar").bold()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty || viewModel.isLoading)
                    
                    Spacer()
                }
                .padding()
                .padding(.top, 100)
                
                // Navegação automática para MainView
                NavigationLink(destination: MainView(), isActive: $viewModel.didRegister) {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
