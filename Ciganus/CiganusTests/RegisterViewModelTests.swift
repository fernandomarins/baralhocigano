//
//  RegisterViewModelTests.swift
//  CiganusTests
//
//  Created by Fernando Marins on 10/04/25.
//

import XCTest
@testable import Ciganus

@MainActor
final class RegisterViewModelTests: XCTestCase {
    
    var sut: RegisterViewModel!
    var mockService: MockAuthService!
    
    override func setUp() {
        super.setUp()
        mockService = MockAuthService()
        sut = RegisterViewModel(service: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func testRegister_Success() async {
        // Given
        sut.email = "new@example.com"
        sut.password = "password123"
        mockService.shouldSucceed = true
        
        // When
        await sut.register()
        
        // Then
        XCTAssertTrue(sut.didRegister)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testRegister_Failure() async {
        // Given
        sut.email = "new@example.com"
        sut.password = "password123"
        mockService.shouldSucceed = false
        mockService.errorToThrow = AppError.custom("Erro ao registrar")
        
        // When
        await sut.register()
        
        // Then
        XCTAssertFalse(sut.didRegister)
        XCTAssertEqual(sut.errorMessage, "Erro ao registrar")
        XCTAssertFalse(sut.isLoading)
    }
    
    func testRegister_WeakPassword() async {
        // Given
        sut.email = "new@example.com"
        sut.password = "123" // Too short
        
        // When
        await sut.register()
        
        // Then
        XCTAssertFalse(sut.didRegister)
        XCTAssertEqual(sut.errorMessage, "A senha deve ter pelo menos 6 caracteres.")
    }
}
