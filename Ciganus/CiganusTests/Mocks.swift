//
//  Mocks.swift
//  CiganusTests
//
//  Created by Fernando Marins on 10/04/25.
//

import Foundation
import FirebaseAuth
@testable import Ciganus

class MockAuthService: AuthServicing {
    var shouldSucceed = true
    var errorToThrow: Error?
    var currentUser: User?
    
    func login(email: String, password: String) async throws {
        if !shouldSucceed {
            throw errorToThrow ?? AppError.unknown(NSError(domain: "Mock", code: -1))
        }
    }
    
    func register(email: String, password: String) async throws {
        if !shouldSucceed {
            throw errorToThrow ?? AppError.unknown(NSError(domain: "Mock", code: -1))
        }
    }
    
    func logout() throws {
        if !shouldSucceed {
            throw errorToThrow ?? AppError.unknown(NSError(domain: "Mock", code: -1))
        }
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
}

class MockCardService: CardServicing {
    var shouldSucceed = true
    var errorToThrow: Error?
    var cardsToReturn: [Card] = []
    
    func fetchCartasTyped() async throws -> [Card] {
        if !shouldSucceed {
            throw errorToThrow ?? AppError.unknown(NSError(domain: "Mock", code: -1))
        }
        return cardsToReturn
    }
}
