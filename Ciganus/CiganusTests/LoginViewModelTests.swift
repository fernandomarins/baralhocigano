//
//  LoginViewModelTests.swift
//  CiganusTests
//
//  Created by Fernando Marins on 10/04/25.
//

import XCTest
@testable import Ciganus

@MainActor
final class LoginViewModelTests: XCTestCase {
    
    var sut: LoginViewModel!
    var mockUseCase: MockLoginUseCase!
    var mockRepo: MockAuthRepository!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockLoginUseCase()
        mockRepo = MockAuthRepository()
        sut = LoginViewModel(loginUseCase: mockUseCase, authRepository: mockRepo)
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        mockRepo = nil
        super.tearDown()
    }
    
    func testLogin_Success() async {
        // Given
        sut.email = "test@example.com"
        sut.password = "password123"
        mockUseCase.shouldSucceed = true
        
        // When
        await sut.login()
        
        // Then
        XCTAssertTrue(sut.didLogin)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testLogin_Failure() async {
        // Given
        sut.email = "test@example.com"
        sut.password = "password123"
        mockUseCase.shouldSucceed = false
        mockUseCase.errorToThrow = AppError.invalidCredentials
        
        // When
        await sut.login()
        
        // Then
        XCTAssertFalse(sut.didLogin)
        XCTAssertEqual(sut.errorMessage, AppError.invalidCredentials.localizedDescription)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testLogin_InvalidEmail() async {
        // Given
        sut.email = "invalid-email"
        sut.password = "password123"
        
        // When
        await sut.login()
        
        // Then
        XCTAssertFalse(sut.didLogin)
        XCTAssertEqual(sut.errorMessage, "Email inválido.")
    }
    
    func testLogin_EmptyPassword() async {
        // Given
        sut.email = "test@example.com"
        sut.password = ""
        
        // When
        await sut.login()
        
        // Then
        XCTAssertFalse(sut.didLogin)
        XCTAssertEqual(sut.errorMessage, "Preencha a senha.")
    }
}
