//
//  ValidatorTests.swift
//  CiganusTests
//
//  Created by Fernando Marins on 10/04/25.
//

import XCTest
@testable import Ciganus

final class ValidatorTests: XCTestCase {
    
    func testIsValidEmail_Valid() {
        XCTAssertTrue(Validator.isValidEmail("test@example.com"))
        XCTAssertTrue(Validator.isValidEmail("user.name@domain.co.uk"))
    }
    
    func testIsValidEmail_Invalid() {
        XCTAssertFalse(Validator.isValidEmail("invalid-email"))
        XCTAssertFalse(Validator.isValidEmail("test@"))
        XCTAssertFalse(Validator.isValidEmail("@example.com"))
        XCTAssertFalse(Validator.isValidEmail("test@example"))
    }
    
    func testIsValidPassword_Valid() {
        XCTAssertTrue(Validator.isValidPassword("123456"))
        XCTAssertTrue(Validator.isValidPassword("password"))
    }
    
    func testIsValidPassword_Invalid() {
        XCTAssertFalse(Validator.isValidPassword("12345"))
        XCTAssertFalse(Validator.isValidPassword(""))
    }
}
