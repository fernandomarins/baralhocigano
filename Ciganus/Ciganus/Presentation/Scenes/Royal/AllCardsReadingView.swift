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
                CosmicBackground()
                
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
    
    private var headerView: some View {
        Text("Leitura da Mesa Real Kármica")
            .font(.largeTitle)
            .bold()
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

#Preview {
    AllCardsReadingView(selectedCardNumbers: [:], allCards: [], sectionTitles: [])
}
