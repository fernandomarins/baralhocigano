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
    var mockService: MockAuthService!
    
    override func setUp() {
        super.setUp()
        mockService = MockAuthService()
        sut = LoginViewModel(service: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func testLogin_Success() async {
        // Given
        sut.email = "test@example.com"
        sut.password = "password123"
        mockService.shouldSucceed = true
        
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
        mockService.shouldSucceed = false
        mockService.errorToThrow = AppError.invalidCredentials
        
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
