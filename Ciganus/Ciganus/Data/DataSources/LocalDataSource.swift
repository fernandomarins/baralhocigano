//
//  LocalDataSource.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import Foundation
import SwiftData

protocol LocalDataSourceProtocol {
    func fetchAllCards() throws -> [Card]
    func save(cards: [Card]) throws
    func deleteAll() throws
    func count() throws -> Int
    func getLocalVersion() -> Int
    func setLocalVersion(_ version: Int)
}

class LocalDataSource: LocalDataSourceProtocol {
    private let defaults: UserDefaults
    private let versionKey = "local_data_version"
    private let swiftDataRepo: SwiftDataRepository<Card>
    
    init(context: ModelContext, defaults: UserDefaults = .standard) {
        self.swiftDataRepo = SwiftDataRepository<Card>(context: context)
        self.defaults = defaults
    }
    
    func fetchAllCards() throws -> [Card] {
        return try swiftDataRepo.fetchAll()
    }
    
    func save(cards: [Card]) throws {
        try swiftDataRepo.save(cards)
    }
    
    func deleteAll() throws {
        try swiftDataRepo.deleteAll()
    }
    
    func count() throws -> Int {
        return try swiftDataRepo.count()
    }
    
    func getLocalVersion() -> Int {
        return defaults.integer(forKey: versionKey)
    }
    
    func setLocalVersion(_ version: Int) {
        defaults.set(version, forKey: versionKey)
    }
}
