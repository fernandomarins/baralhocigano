//
//  MainViewModelTests.swift
//  CiganusTests
//
//  Created by Fernando Marins on 10/04/25.
//

import XCTest
@testable import Ciganus

@MainActor
final class MainViewModelTests: XCTestCase {
    
    var sut: MainViewModel!
    var mockService: MockCardService!
    
    override func setUp() {
        super.setUp()
        mockService = MockCardService()
        sut = MainViewModel(service: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func testCarregarCartas_Success() async {
        // Given
        let mockCards = [
            Card(number: "1", name: "Carta 1", keywords: "", generalMeanings: "", astrologicalInfluence: "", archetypeFigure: "", spiritualPlane: "", mentalPlane: "", emotionalPlane: "", materialPlane: "", physicalPlane: "", positivePoints: "", negativePoints: "", yearPrediction: "", time: ""),
            Card(number: "2", name: "Carta 2", keywords: "", generalMeanings: "", astrologicalInfluence: "", archetypeFigure: "", spiritualPlane: "", mentalPlane: "", emotionalPlane: "", materialPlane: "", physicalPlane: "", positivePoints: "", negativePoints: "", yearPrediction: "", time: "")
        ]
        mockService.cardsToReturn = mockCards
        mockService.shouldSucceed = true
        
        // When
        await sut.carregarCartas()
        
        // Then
        XCTAssertEqual(sut.cards.count, 2)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testCarregarCartas_Failure() async {
        // Given
        mockService.shouldSucceed = false
        mockService.errorToThrow = AppError.custom("Erro de conexão")
        
        // When
        await sut.carregarCartas()
        
        // Then
        XCTAssertTrue(sut.cards.isEmpty)
        XCTAssertEqual(sut.errorMessage, "Erro ao carregar cartas: Erro de conexão")
        XCTAssertFalse(sut.isLoading)
    }
}
