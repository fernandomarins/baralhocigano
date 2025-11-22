//
//  FirebaseDataSource.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

protocol FirebaseDataSourceProtocol {
    func fetchRemoteVersion() async throws -> Int
    func fetchAllCards() async throws -> [Card]
    func login(email: String, password: String) async throws
    func register(email: String, password: String) async throws
    func logout() throws
    func getCurrentUser() -> User?
}

class FirebaseDataSource: FirebaseDataSourceProtocol {
    private let databaseRef = Database.database().reference()
    
    func fetchRemoteVersion() async throws -> Int {
        print("FirebaseDataSource: Fetching remote version...")
        let snapshot = try await databaseRef.child("metadata/version").getData()
        let version = snapshot.value as? Int ?? 0
        print("FirebaseDataSource: Remote version = \(version)")
        return version
    }
    
    func fetchAllCards() async throws -> [Card] {
        print("FirebaseDataSource: Fetching all cards from root...")
        let snapshot = try await databaseRef.getData()
        guard let value = snapshot.value as? [[String: Any]] else {
            print("FirebaseDataSource: No cards found or invalid format. Snapshot value type: \(type(of: snapshot.value))")
            return []
        }
        
        print("FirebaseDataSource: Found \(value.count) cards in Firebase")
        
        let cards: [Card] = value.compactMap { dict in
            do {
                let data = try JSONSerialization.data(withJSONObject: dict)
                return try JSONDecoder().decode(Card.self, from: data)
            } catch {
                print("FirebaseDataSource: Error decoding card: \(error)")
                return nil
            }
        }
        
        print("FirebaseDataSource: Successfully decoded \(cards.count) cards")
        return cards
    }
    
    func login(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func register(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
}
