//
//  RegisterViewModel.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import Foundation

@MainActor
class RegisterViewModel: ObservableObject {
    private let registerUseCase: RegisterUseCaseProtocol
    
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var didRegister = false

    init(registerUseCase: RegisterUseCaseProtocol = DependencyContainer.shared.registerUseCase) {
        self.registerUseCase = registerUseCase
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
            try await registerUseCase.execute(email: email, password: password)
            didRegister = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
