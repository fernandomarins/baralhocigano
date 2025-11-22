//
//  LoginViewModel.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import Foundation
import FirebaseAuth
import LocalAuthentication

@MainActor
@Observable class LoginViewModel: ObservableObject {
    private let loginUseCase: LoginUseCaseProtocol
    private let authRepository: AuthRepositoryProtocol // For checkLoginStatus/FaceID which might need direct repo access or separate UseCase
    
    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?
    var didLogin = false

    init(loginUseCase: LoginUseCaseProtocol = DependencyContainer.shared.loginUseCase,
         authRepository: AuthRepositoryProtocol = DependencyContainer.shared.authRepository) {
        self.loginUseCase = loginUseCase
        self.authRepository = authRepository
    }

    func login() async {
        guard Validator.isValidEmail(email) else {
            self.errorMessage = "Email inválido."
            return
        }
        
        guard !password.isEmpty else {
            self.errorMessage = "Preencha a senha."
            return
        }

        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }

        do {
            try await loginUseCase.execute(email: email, password: password)
            didLogin = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func checkLoginStatus() async {
        if authRepository.getCurrentUser() != nil {
            didLogin = true
        }
    }
    
    func authenticateWithFaceID() async -> Bool {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Autentique-se para entrar no aplicativo."

            do {
                let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                if success {
                    return true
                } else {
                    return false
                }
            } catch {
                print("Erro de autenticação: \(error.localizedDescription)")
                return false
            }
        } else {
            print("Autenticação biométrica não disponível.")
            return false
        }
    }
}
