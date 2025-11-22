//
//  DatabaseRepository.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import Foundation
import SwiftData

protocol Repository {
    associatedtype T: PersistentModel
    
    func fetchAll() throws -> [T]
    func save(_ items: [T]) throws
    func deleteAll() throws
    func count() throws -> Int
}

class SwiftDataRepository<T: PersistentModel>: Repository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchAll() throws -> [T] {
        let descriptor = FetchDescriptor<T>()
        return try context.fetch(descriptor)
    }
    
    func save(_ items: [T]) throws {
        for item in items {
            context.insert(item)
        }
        try context.save()
    }
    
    func deleteAll() throws {
        // Manual delete loop to avoid batch delete issues
        let items = try fetchAll()
        for item in items {
            context.delete(item)
        }
        try context.save()
    }
    
    func count() throws -> Int {
        let descriptor = FetchDescriptor<T>()
        return try context.fetchCount(descriptor)
    }
}
