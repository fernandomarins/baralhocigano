//
//  RegisterViewModel.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import Foundation

@Observable class RegisterViewModel: ObservableObject {
    var email = ""
    var password = ""
    var errorMessage: String?
    var isLoading = false
    var didRegister = false

    func register() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Preencha todos os campos"
            return
        }

        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
       
        do {
            try await Service.shared.register(email: email, password: password)
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
