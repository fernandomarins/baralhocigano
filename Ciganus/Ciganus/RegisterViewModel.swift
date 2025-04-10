//
//  RegisterViewModel.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import Foundation
import FirebaseAuth

class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var didRegister = false

    func register() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Preencha todos os campos"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let _ = try await Auth.auth().createUser(withEmail: email, password: password)
            DispatchQueue.main.async {
                self.didRegister = true
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
