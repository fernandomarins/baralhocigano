//
//  MainViewModel.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI
import FirebaseDatabase

import SwiftData

@MainActor
class MainViewModel: ObservableObject {
    private let service: CardServicing
    private var modelContext: ModelContext?
    
    @Published var cards: [Card] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(service: CardServicing = CardService.shared) {
        self.service = service
    }
    
    func setContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func loadData() {
        guard let context = modelContext else { return }
        
        // 1. Carregar dados locais imediatamente
        do {
            let descriptor = FetchDescriptor<Card>(sortBy: [SortDescriptor(\.number)])
            self.cards = try context.fetch(descriptor)
        } catch {
            print("Erro ao carregar dados locais: \(error)")
        }
        
        // 2. Sincronizar em background
        Task {
            await syncData()
        }
    }
    
    private func syncData() async {
        guard let context = modelContext else { return }
        
        if cards.isEmpty {
            isLoading = true
        }
        defer { isLoading = false }
        
        do {
            try await service.sync(modelContext: context)
            // Recarregar após sync
            let descriptor = FetchDescriptor<Card>(sortBy: [SortDescriptor(\.number)])
            self.cards = try context.fetch(descriptor)
        } catch {
            // Se falhar o sync, apenas logamos, pois os dados locais já estão sendo mostrados (se houver)
            print("Erro na sincronização: \(error)")
            // Opcional: errorMessage = "Modo Offline: Não foi possível sincronizar."
        }
    }
    
    // Mantido para compatibilidade, mas redireciona para loadData se contexto estiver setado
    func carregarCartas() async {
        if modelContext != nil {
            loadData()
        } else {
            // Fallback antigo ou erro
            errorMessage = "Erro interno: Contexto não configurado."
        }
    }
}
