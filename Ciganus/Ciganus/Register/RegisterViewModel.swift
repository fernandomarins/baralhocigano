//
//  RegisterViewModel.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import Foundation

@MainActor
@Observable class RegisterViewModel: ObservableObject {
    private let service: AuthServicing
    
    var email = ""
    var password = ""
    var errorMessage: String?
    var isLoading = false
    var didRegister = false

    init(service: AuthServicing = AuthService.shared) {
        self.service = service
    }

    func register() async {
        guard Validator.isValidEmail(email) else {
            errorMessage = "Email inválido."
            return
        }
        
        guard Validator.isValidPassword(password) else {
            errorMessage = "A senha deve ter pelo menos 6 caracteres."
            return
        }

        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
       
        do {
            try await service.register(email: email, password: password)
            didRegister = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
