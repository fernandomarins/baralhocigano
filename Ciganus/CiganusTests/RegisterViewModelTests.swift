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
    var mockUseCase: MockRegisterUseCase!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockRegisterUseCase()
        sut = RegisterViewModel(registerUseCase: mockUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    func testRegister_Success() async {
        // Given
        sut.email = "new@example.com"
        sut.password = "password123"
        mockUseCase.shouldSucceed = true
        
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
        mockUseCase.shouldSucceed = false
        mockUseCase.errorToThrow = AppError.custom("Erro ao registrar")
        
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
