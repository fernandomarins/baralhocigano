//
//  AuthService.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol Servicing {
    func login(email: String, password: String) async throws
    func register(email: String, password: String) async throws
    func fetchCartasTyped() async throws -> [Card]
    func logout() throws
    func getCurrentUser() -> User?
}

class Service: Servicing {
    static let shared = Service()
    
    private init() {}

    func login(email: String, password: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    func register(email: String, password: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    func fetchCartasTyped() async throws -> [Card] {
        try await withCheckedThrowingContinuation { continuation in
            let ref = Database.database().reference()
            
            ref.observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [[String: Any]] else {
                    continuation.resume(throwing: NSError(domain: "Invalid data format", code: 0))
                    return
                }
                
                let cartas: [Card] = value.compactMap { dict in
                    do {
                        let data = try JSONSerialization.data(withJSONObject: dict)
                        return try JSONDecoder().decode(Card.self, from: data)
                    } catch {
                        print("Erro ao decodificar carta: \(error)")
                        return nil
                    }
                }
                
                continuation.resume(returning: cartas)
            }
        }
    }

    func logout() throws {
        try Auth.auth().signOut()
    }

    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
}
