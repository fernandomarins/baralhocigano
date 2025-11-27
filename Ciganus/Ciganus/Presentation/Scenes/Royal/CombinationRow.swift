//
//  CombinationRow.swift
//  Ciganus
//
//  Created by Fernando Marins on 26/11/25.
//

import SwiftUI

struct CombinationRow: View {
    let sectionIndex: Int
    let pairIndex: Int
    let selectedCardNumbers: [Int: String]
    let allCards: [Card]
    let combinedCards: [CombinedCardModel]
    
    var body: some View {
        let firstIndex = sectionIndex * 6 + pairIndex
        let secondIndex = sectionIndex * 6 + pairIndex + 1
        
        if let card1 = getCard(at: firstIndex),
           let card2 = getCard(at: secondIndex),
           let num1 = selectedCardNumbers[firstIndex],
           let num2 = selectedCardNumbers[secondIndex] {
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Combinação \(num1) + \(num2): \(card1.name) + \(card2.name)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .bold()
                
                Text("Significado:")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(getCombinationDescription(card1Name: card1.name, card2Name: card2.name))
                    .foregroundColor(.white.opacity(0.9))
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.4))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [.purple.opacity(0.3), .cyan.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            
        } else {
            Text("Par \(pairIndex + 1): Cartas não selecionadas")
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
                .padding(.vertical, 4)
        }
    }
    
    private func getCard(at globalIndex: Int) -> Card? {
        guard let numberString = selectedCardNumbers[globalIndex],
              let number = Int(numberString) else {
            return nil
        }
        return allCards.first { Int($0.number) == number }
    }
    
    private func getCombinationDescription(card1Name: String, card2Name: String) -> String {
        let combinationKey = "\(card1Name), \(card2Name)".lowercased()
        if let combination = combinedCards.first(where: { $0.number.lowercased() == combinationKey }) {
            return combination.description
        } else {
            return "Nenhuma combinação encontrada para \(card1Name) e \(card2Name)."
        }
    }
}
