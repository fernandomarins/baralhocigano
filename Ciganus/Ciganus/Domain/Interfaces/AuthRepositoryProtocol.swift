//
//  AuthRepositoryProtocol.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import Foundation
import FirebaseAuth

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws
    func register(email: String, password: String) async throws
    func logout() throws
    func getCurrentUser() -> User?
}
