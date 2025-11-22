//
//  Mocks.swift
//  CiganusTests
//
//  Created by Fernando Marins on 10/04/25.
//

import Foundation
import FirebaseAuth
import SwiftData
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
    
    func fetchCartas() async throws -> [Card] {
        if !shouldSucceed {
            throw errorToThrow ?? AppError.unknown(NSError(domain: "Mock", code: -1))
        }
        return cardsToReturn
    }
    
    func sync(modelContext: ModelContext) async throws {
        if !shouldSucceed {
            throw errorToThrow ?? AppError.unknown(NSError(domain: "Mock", code: -1))
        }
    }
}

// MARK: - UseCase Mocks

class MockLoginUseCase: LoginUseCaseProtocol {
    var shouldSucceed = true
    var errorToThrow: Error?
    
    func execute(email: String, password: String) async throws {
        if !shouldSucceed {
            throw errorToThrow ?? AppError.unknown(NSError(domain: "Mock", code: -1))
        }
    }
}

class MockRegisterUseCase: RegisterUseCaseProtocol {
    var shouldSucceed = true
    var errorToThrow: Error?
    
    func execute(email: String, password: String) async throws {
        if !shouldSucceed {
            throw errorToThrow ?? AppError.unknown(NSError(domain: "Mock", code: -1))
        }
    }
}

class MockFetchCardsUseCase: FetchCardsUseCaseProtocol {
    var shouldSucceed = true
    var errorToThrow: Error?
    var cardsToReturn: [Card] = []
    
    @MainActor
    func execute(context: ModelContext) async throws -> [Card] {
        if !shouldSucceed {
            throw errorToThrow ?? AppError.unknown(NSError(domain: "Mock", code: -1))
        }
        return cardsToReturn
    }
}

class MockAuthRepository: AuthRepositoryProtocol {
    var currentUser: User?
    
    func login(email: String, password: String) async throws {}
    func register(email: String, password: String) async throws {}
    func logout() throws {}
    func getCurrentUser() -> User? { return currentUser }
}
