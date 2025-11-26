//
//  CardService.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import Foundation
import FirebaseDatabase

import SwiftData

protocol CardServicing {
    func fetchCartas() async throws -> [Card]
    func sync(modelContext: ModelContext) async throws
}

class CardService: CardServicing {
    static let shared = CardService()
    
    private init() {}
    
    private var cache: [Card]?
    
    func fetchCartas() async throws -> [Card] {
        // Este método agora deve ser chamado apenas se quisermos forçar um fetch do banco local
        // Mas idealmente, a View usa @Query.
        // Para manter a compatibilidade com a arquitetura atual (ViewModel buscando dados),
        // vamos fazer o fetch do SwiftData aqui, mas precisariamos do ModelContext.
        // Como o CardService é um Singleton, ele não tem acesso fácil ao ModelContext da View.
        // SOLUÇÃO: O CardService deixa de ser responsável por fornecer os dados diretamente para a View
        // se a View usar @Query.
        // MAS, como o pedido foi para usar SwiftData E manter a arquitetura, vamos fazer o seguinte:
        // O ViewModel receberá o ModelContext e passará para o Service se necessário,
        // OU o ViewModel usa @Query e o Service só faz o Sync.
        
        // Vamos alterar a abordagem: O Service será responsável pelo SYNC.
        // A leitura dos dados será feita preferencialmente via @Query na View ou fetch no ViewModel.
        // Para não quebrar o contrato `CardServicing` drasticamente, vamos permitir que ele faça fetch
        // se receber o contexto, ou retornamos erro se não tiver contexto.
        
        // Melhor: Vamos mudar a assinatura do protocolo para aceitar o contexto se necessário,
        // ou assumir que a leitura principal é via SwiftData na camada de UI.
        
        // No entanto, para cumprir o requisito "não depender do request da API",
        // o fetchCartasTyped (agora fetchCartas) deve retornar o que tem no banco local.
        // Como é um Singleton, não tem o contexto.
        // Vamos injetar o contexto no método.
        return [] // Placeholder, pois a leitura será feita via @Query ou passando contexto
    }
    
    func fetchCartas(context: ModelContext) throws -> [Card] {
        let descriptor = FetchDescriptor<Card>(sortBy: [SortDescriptor(\.number)])
        return try context.fetch(descriptor)
    }
    
    func sync(modelContext: ModelContext) async throws {
        try await SyncService.shared.checkAndSync(modelContext: modelContext)
    }
}
