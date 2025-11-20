//
//  MainViewModelTests.swift
//  CiganusTests
//
//  Created by Fernando Marins on 10/04/25.
//

import XCTest
import SwiftData
@testable import Ciganus

@MainActor
final class MainViewModelTests: XCTestCase {
    
    var sut: MainViewModel!
    var mockService: MockCardService!
    var container: ModelContainer!
    
    override func setUp() {
        super.setUp()
        mockService = MockCardService()
        sut = MainViewModel(service: mockService)
        
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            container = try ModelContainer(for: Card.self, configurations: config)
            sut.setContext(container.mainContext)
        } catch {
            XCTFail("Failed to create in-memory container")
        }
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func testLoadData_Success_Local() {
        // Given
        let card1 = Card(number: "1", name: "Carta 1", keywords: "", generalMeanings: "", astrologicalInfluence: "", archetypeFigure: "", spiritualPlane: "", mentalPlane: "", emotionalPlane: "", materialPlane: "", physicalPlane: "", positivePoints: "", negativePoints: "", yearPrediction: "", time: "")
        let card2 = Card(number: "2", name: "Carta 2", keywords: "", generalMeanings: "", astrologicalInfluence: "", archetypeFigure: "", spiritualPlane: "", mentalPlane: "", emotionalPlane: "", materialPlane: "", physicalPlane: "", positivePoints: "", negativePoints: "", yearPrediction: "", time: "")
        
        let context = container.mainContext
        context.insert(card1)
        context.insert(card2)
        
        // When
        sut.loadData()
        
        // Then
        if case .success(let cards) = sut.state {
            XCTAssertEqual(cards.count, 2)
        } else {
            XCTFail("State should be success")
        }
    }
    
    func testLoadData_Empty_Loading() {
        // Given
        // No data in context
        
        // When
        sut.loadData()
        
        // Then
        if case .loading = sut.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("State should be loading when DB is empty")
        }
    }
}
