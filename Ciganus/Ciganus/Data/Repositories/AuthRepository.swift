//
//  AuthRepository.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import Foundation
import FirebaseAuth

class AuthRepository: AuthRepositoryProtocol {
    private let dataSource: FirebaseDataSourceProtocol
    
    init(dataSource: FirebaseDataSourceProtocol = FirebaseDataSource()) {
        self.dataSource = dataSource
    }
    
    func login(email: String, password: String) async throws {
        try await dataSource.login(email: email, password: password)
    }
    
    func register(email: String, password: String) async throws {
        try await dataSource.register(email: email, password: password)
    }
    
    func logout() throws {
        try dataSource.logout()
    }
    
    func getCurrentUser() -> User? {
        return dataSource.getCurrentUser()
    }
}
