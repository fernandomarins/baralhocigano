//
//  MainViewModel.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI
import FirebaseDatabase

class MainViewModel: ObservableObject {
    @Published var cartas: [Card] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func carregarCartas() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let cartas = try await Service.shared.fetchCartasTyped()
                DispatchQueue.main.async {
                    self.cartas = cartas
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
