//
//  CardRepository.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import Foundation
import SwiftData

class CardRepository: CardRepositoryProtocol {
    private let firebaseDataSource: FirebaseDataSourceProtocol
    
    init(firebaseDataSource: FirebaseDataSourceProtocol = FirebaseDataSource()) {
        self.firebaseDataSource = firebaseDataSource
    }
    
    // Overloaded method to support context
    func fetchCards(context: ModelContext) throws -> [Card] {
        let localDataSource = LocalDataSource(context: context)
        return try localDataSource.fetchAllCards()
    }
    
    @MainActor
    func sync(modelContext: ModelContext) async throws {
        let localDataSource = LocalDataSource(context: modelContext)
        let remoteVersion = try await firebaseDataSource.fetchRemoteVersion()
        let localVersion = localDataSource.getLocalVersion()
        let localCount = try localDataSource.count()
        
        print("SyncService: Versão Local: \(localVersion), Versão Remota: \(remoteVersion), Cartas Locais: \(localCount)")
        
        if remoteVersion > localVersion || localVersion == 0 || localCount == 0 {
            print("SyncService: Iniciando sincronização...")
            let cards = try await firebaseDataSource.fetchAllCards()
            try localDataSource.deleteAll()
            try localDataSource.save(cards: cards)
            localDataSource.setLocalVersion(remoteVersion)
            print("SyncService: Sincronização concluída. Total de cartas: \(cards.count)")
        } else {
            print("SyncService: Dados já estão atualizados.")
        }
    }
}
