//
//  CombinedCardsViewModel.swift
//  Ciganus
//
//  Created by Fernando Marins on 26/11/25.
//

import SwiftUI
import Combine

@MainActor
class CombinedCardsViewModel: ObservableObject {
    @Published var cardNumber1: String = ""
    @Published var cardNumber2: String = ""
    @Published var combinedDescription: String = ""
    @Published var nameFirstCard: String = ""
    @Published var nameSecondCard: String = ""
    @Published var combinedCards: [CombinedCardModel] = []
    
    var isValidInput: Bool {
        guard let num1 = Int(cardNumber1), let num2 = Int(cardNumber2) else { return false }
        return (1...36).contains(num1) && (1...36).contains(num2) && num1 != num2
    }
    
    func loadCards() {
        do {
            combinedCards = try CombinedCards().getCombinedCards()
        } catch {
            print("Erro ao carregar as cartas combinadas: \(error)")
        }
    }
    
    func buscarCombinacaoPorNomes() {
        guard let num1 = Int(cardNumber1), let num2 = Int(cardNumber2),
              let nomeCarta1 = Source.shared.name(for: num1),
              let nomeCarta2 = Source.shared.name(for: num2) else {
            return
        }
        
        nameFirstCard = nomeCarta1
        nameSecondCard = nomeCarta2
        
        let combinedName = "\(nomeCarta1), \(nomeCarta2)"
        
        if let foundCard = combinedCards.first(where: { $0.number.lowercased() == combinedName.lowercased() }) {
            combinedDescription = foundCard.description
        } else {
            combinedDescription = "Nenhuma combinação encontrada para \(combinedName)"
        }
    }
}
