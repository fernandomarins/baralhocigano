//
//  LoginView.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var navigateToMain = false
    @State private var showRegister = false
    
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
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                    
                    SecureField("Senha", text: $viewModel.password)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                    
                    Button(action: {
                        Task {
                            await viewModel.login()
                        }
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Entrar")
                                    .bold()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }
                    .opacity(viewModel.email.isEmpty || viewModel.password.isEmpty || viewModel.isLoading ? 0.5 : 1)
                    
                    Button("Usar Face ID") {
                        Task {
                            if await viewModel.authenticateWithFaceID() {
                                navigateToMain = true
                            } else {
                                viewModel.errorMessage = "Falha na autenticação por Face ID."
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.top)
                    
                    Button("Criar conta") {
                        showRegister = true
                    }
                    .foregroundColor(.white)
                    .padding(.top)
                    
                    .navigationDestination(isPresented: $viewModel.didLogin) {
                        MainView()
                    }
                    .navigationDestination(isPresented: $showRegister) {
                        RegisterView()
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $navigateToMain) {
                MainView()
            }
        }
        .onAppear {
            Task {
                await viewModel.checkLoginStatus()
            }
        }
        .onChange(of: viewModel.didLogin, { _, isLogged in
            if isLogged {
                navigateToMain = true
            }
        })
    }
}

#Preview {
    LoginView()
}
