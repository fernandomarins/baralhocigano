//
//  LoginUseCase.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import Foundation

protocol LoginUseCaseProtocol {
    func execute(email: String, password: String) async throws
}

class LoginUseCase: LoginUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(email: String, password: String) async throws {
        guard Validator.isValidEmail(email) else {
            throw AppError.custom("Email inválido.")
        }
        guard !password.isEmpty else {
            throw AppError.custom("Preencha a senha.")
        }
        
        try await repository.login(email: email, password: password)
    }
}
