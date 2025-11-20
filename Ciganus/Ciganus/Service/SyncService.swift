//
//  SyncService.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import Foundation
import FirebaseDatabase
import SwiftData
import SwiftUI

@MainActor
class SyncService {
    static let shared = SyncService()
    
    private let versionKey = "cards_data_version"
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    func checkAndSync(modelContext: ModelContext) async throws {
        let remoteVersion = try await fetchRemoteVersion()
        let localVersion = defaults.integer(forKey: versionKey)
        
        let descriptor = FetchDescriptor<Card>()
        let localCount = try modelContext.fetchCount(descriptor)
        
        print("Versão Local: \(localVersion), Versão Remota: \(remoteVersion), Cartas Locais: \(localCount)")
        
        if remoteVersion > localVersion || localVersion == 0 || localCount == 0 {
            print("Iniciando sincronização...")
            let cards = try await fetchAllCards()
            try await updateLocalDatabase(cards: cards, context: modelContext)
            defaults.set(remoteVersion, forKey: versionKey)
            print("Sincronização concluída. Total de cartas: \(cards.count)")
        } else {
            print("Dados já estão atualizados e validados.")
        }
    }
    
    private func fetchRemoteVersion() async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            // Supondo um nó "metadata/version" no Firebase.
            // Se não existir, retornamos 1 para forçar o primeiro sync (se local for 0).
            let ref = Database.database().reference().child("metadata").child("version")
            
            ref.observeSingleEvent(of: .value) { snapshot in
                let version = snapshot.value as? Int ?? 1
                continuation.resume(returning: version)
            } withCancel: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    private func fetchAllCards() async throws -> [Card] {
        // Reutiliza a lógica de fetch do CardService, mas aqui focada em pegar os dados brutos
        // Na verdade, podemos duplicar a lógica simples aqui ou chamar um método estático se houvesse.
        // Vamos implementar a busca direta aqui para desacoplar do CardService antigo.
        return try await withCheckedThrowingContinuation { continuation in
            // O código original do CardService buscava na raiz, vamos manter a consistência.
            let rootRef = Database.database().reference()
            
            rootRef.observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [[String: Any]] else {
                    continuation.resume(throwing: AppError.custom("Formato de dados inválido"))
                    return
                }
                
                let cards: [Card] = value.compactMap { dict in
                    do {
                        let data = try JSONSerialization.data(withJSONObject: dict)
                        return try JSONDecoder().decode(Card.self, from: data)
                    } catch {
                        print("Erro ao decodificar carta no sync: \(error)")
                        return nil
                    }
                }
                
                continuation.resume(returning: cards)
            } withCancel: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    private func updateLocalDatabase(cards: [Card], context: ModelContext) async throws {
        // Limpar dados antigos
        // Limpar dados antigos (Manual delete to avoid NSFetchRequest error with batch delete)
        let descriptor = FetchDescriptor<Card>()
        let existingCards = try context.fetch(descriptor)
        for card in existingCards {
            context.delete(card)
        }
        
        // Salvar novos
        for card in cards {
            context.insert(card)
        }
        
        try context.save()
    }
}
