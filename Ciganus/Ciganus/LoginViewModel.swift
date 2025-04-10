//
//  LoginViewModel.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didLogin = false

    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Preencha todos os campos"
            return
        }

        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }

        do {
            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
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
}
