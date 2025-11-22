//
//  RegisterUseCase.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import Foundation

protocol RegisterUseCaseProtocol {
    func execute(email: String, password: String) async throws
}

class RegisterUseCase: RegisterUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(email: String, password: String) async throws {
        guard Validator.isValidEmail(email) else {
            throw AppError.custom("Email inválido.")
        }
        guard Validator.isValidPassword(password) else {
            throw AppError.custom("A senha deve ter pelo menos 6 caracteres.")
        }
        
        try await repository.register(email: email, password: password)
    }
}
