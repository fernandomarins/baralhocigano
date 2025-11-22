//
//  FetchCardsUseCase.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import Foundation
import SwiftData

protocol FetchCardsUseCaseProtocol {
    @MainActor func execute(context: ModelContext) async throws -> [Card]
}

class FetchCardsUseCase: FetchCardsUseCaseProtocol {
    private let repository: CardRepositoryProtocol
    
    init(repository: CardRepositoryProtocol) {
        self.repository = repository
    }
    
    @MainActor
    func execute(context: ModelContext) async throws -> [Card] {
        // 1. Trigger sync (which handles version check and local update)
        try await repository.sync(modelContext: context)
        
        // 2. Fetch updated data from local DB
        let cards = try repository.fetchCards(context: context)
        print("FetchCardsUseCase: Fetched \(cards.count) cards")
        return cards.sorted(by: { $0.number < $1.number })
    }
}
