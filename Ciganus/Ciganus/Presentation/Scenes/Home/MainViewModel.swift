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
    private let fetchCardsUseCase: FetchCardsUseCaseProtocol
    private var modelContext: ModelContext?
    
    @Published var state: ViewState<[Card]> = .idle

    init(fetchCardsUseCase: FetchCardsUseCaseProtocol = DependencyContainer.shared.fetchCardsUseCase) {
        self.fetchCardsUseCase = fetchCardsUseCase
    }
    
    func setContext(_ context: ModelContext) {
        modelContext = context
    }
    
    func loadData() {
        guard let context = modelContext else {
            state = .error("Erro interno: Contexto não configurado.")
            return
        }
        
        let repository = SwiftDataRepository<Card>(context: context)
        
        // 1. Carregar dados locais imediatamente
        do {
            let cards = try repository.fetchAll().sorted(by: { (Int($0.number) ?? 0) < (Int($1.number) ?? 0) })
            if !cards.isEmpty {
                state = .success(cards)
            } else {
                state = .loading
            }
        } catch {
            print("Erro ao carregar dados locais: \(error)")
            state = .error("Erro ao carregar dados locais.")
        }
        
        // 2. Sincronizar em background
        Task {
            await syncData(repository: repository)
        }
    }
    
    private func syncData(repository: SwiftDataRepository<Card>) async {
        guard let context = modelContext else { return }
        
        do {
            // UseCase handles sync and fetch
            let newCards = try await fetchCardsUseCase.execute(context: context)
            state = .success(newCards)
        } catch {
            print("Erro na sincronização: \(error)")
            if case .loading = state {
                state = .error("Não foi possível carregar as cartas. Verifique sua conexão.")
            }
        }
    }
}
