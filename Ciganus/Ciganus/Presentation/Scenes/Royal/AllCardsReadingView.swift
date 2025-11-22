//
//  AllCardsReadingView.swift
//  Ciganus
//
//  Created by Fernando Marins on 13/04/25.
//

import SwiftUI

struct AllCardsReadingView: View {
    // MARK: - Properties
    let selectedCardNumbers: [Int: String]
    let allCards: [Card]
    let sectionTitles: [String]
    
    @State private var combinedCards: [CombinedCardModel] = []
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        headerView
                        
                        ForEach(0..<sectionTitles.count, id: \.self) { sectionIndex in
                            ReadingSectionView(
                                title: sectionTitles[sectionIndex],
                                sectionIndex: sectionIndex,
                                selectedCardNumbers: selectedCardNumbers,
                                allCards: allCards,
                                combinedCards: combinedCards
                            )
                            
                            if sectionIndex < sectionTitles.count - 1 {
                                Divider().background(Color.white.opacity(0.5))
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fechar") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            loadCombinedCards()
        }
    }
    
    // MARK: - Subviews
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.indigo, Color.blue]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var headerView: some View {
        Text("Leitura da Mesa Real Kármica")
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding(.vertical)
    }
    
    // MARK: - Logic
    
    private func loadCombinedCards() {
        do {
            combinedCards = try CombinedCards().getCombinedCards()
        } catch {
            print("Erro ao carregar as cartas combinadas: \(error)")
        }
    }
}

// MARK: - Helper Views

private struct ReadingSectionView: View {
    let title: String
    let sectionIndex: Int
    let selectedCardNumbers: [Int: String]
    let allCards: [Card]
    let combinedCards: [CombinedCardModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 4)
            
            ForEach(0..<5, id: \.self) { pairIndex in
                CombinationRow(
                    sectionIndex: sectionIndex,
                    pairIndex: pairIndex,
                    selectedCardNumbers: selectedCardNumbers,
                    allCards: allCards,
                    combinedCards: combinedCards
                )
            }
        }
    }
}

private struct CombinationRow: View {
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
            .background(Color.black.opacity(0.2))
            .cornerRadius(8)
            
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

#Preview {
    AllCardsReadingView(selectedCardNumbers: [:], allCards: [], sectionTitles: [])
}
