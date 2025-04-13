//
//  MainViewModel.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI
import FirebaseDatabase

class MainViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func carregarCartas() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let cards = try await Service.shared.fetchCartasTyped()
                DispatchQueue.main.async {
                    self.cards = cards
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Erro ao carregar cartas: \(error.localizedDescription)"
                }
            }
        }
    }
}
