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
    
    @Published var state: ViewState<[Card]> = .idle

    init(service: CardServicing = CardService.shared) {
        self.service = service
    }
    
    func setContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func loadData() {
        guard let context = modelContext else {
            state = .error("Erro interno: Contexto não configurado.")
            return
        }
        
        let repository = SwiftDataRepository<Card>(context: context)
        
        // 1. Carregar dados locais imediatamente
        do {
            let cards = try repository.fetchAll().sorted(by: { $0.number < $1.number })
            if !cards.isEmpty {
                self.state = .success(cards)
            } else {
                self.state = .loading
            }
        } catch {
            print("Erro ao carregar dados locais: \(error)")
            self.state = .error("Erro ao carregar dados locais.")
        }
        
        // 2. Sincronizar em background
        Task {
            await syncData(repository: repository)
        }
    }
    
    private func syncData(repository: SwiftDataRepository<Card>) async {
        guard let context = modelContext else { return }
        
        do {
            try await service.sync(modelContext: context)
            // Recarregar após sync
            let newCards = try repository.fetchAll().sorted(by: { $0.number < $1.number })
            self.state = .success(newCards)
        } catch {
            print("Erro na sincronização: \(error)")
            if case .loading = state {
                self.state = .error("Não foi possível carregar as cartas. Verifique sua conexão.")
            }
        }
    }
}
