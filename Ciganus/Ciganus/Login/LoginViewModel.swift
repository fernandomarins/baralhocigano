//
//  LoginViewModel.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import Foundation
import FirebaseAuth
import LocalAuthentication

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didLogin = false

    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            DispatchQueue.main.async {
                self.errorMessage = "Preencha todos os campos."
            }
            return
        }

        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }

        do {
            try await Service.shared.login(email: email, password: password)
            DispatchQueue.main.async {
                self.didLogin = true
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }

        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    func checkLoginStatus() async {
        if Service.shared.getCurrentUser() != nil {
            DispatchQueue.main.async {
                self.didLogin = true
            }
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
