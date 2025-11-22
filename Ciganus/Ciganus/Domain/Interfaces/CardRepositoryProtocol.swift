//
//  CardRepositoryProtocol.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import Foundation
import SwiftData

protocol CardRepositoryProtocol {
    func fetchCards(context: ModelContext) throws -> [Card]
    func sync(modelContext: ModelContext) async throws
}
