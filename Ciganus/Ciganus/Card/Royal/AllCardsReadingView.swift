//
//  AllCardsReadingView.swift
//  Ciganus
//
//  Created by Fernando Marins on 13/04/25.
//

import SwiftUI

struct AllCardsReadingView: View {
    let selectedCardNumbers: [Int: String]
    let allCards: [Card]
    let sectionTitles: [String]
    @State private var combinedCards: [CombinedCardModel] = []
    @Environment(\.dismiss) var dismiss

    func getCard(at globalIndex: Int) -> Card? {
        if let cardNumberString = selectedCardNumbers[globalIndex], let cardNumber = Int(cardNumberString) {
            return allCards.first { Int($0.number) == cardNumber }
        }
        return nil
    }

    func getGlobalIndex(for section: Int, row: Int) -> Int {
        return section * 6 + row
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.indigo, Color.blue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Leitura da Mesa Real Kármica")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(.bottom)
                            .padding(.top, 16)

                        ForEach(0..<sectionTitles.count, id: \.self) { sectionIndex in
                            Text(sectionTitles[sectionIndex])
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)

                            ForEach(0..<5, id: \.self) { pairIndex in
                                let firstGlobalIndex = getGlobalIndex(for: sectionIndex, row: pairIndex)
                                let secondGlobalIndex = getGlobalIndex(for: sectionIndex, row: pairIndex + 1)

                                if let firstCard = getCard(at: firstGlobalIndex),
                                   let secondCard = getCard(at: secondGlobalIndex),
                                   let firstNumber = selectedCardNumbers[firstGlobalIndex],
                                   let secondNumber = selectedCardNumbers[secondGlobalIndex] {

                                    VStack(alignment: .leading) {
                                        Text("Combinação \(firstNumber) + \(secondNumber): \(firstCard.name) + \(secondCard.name)")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .bold()
                                            .padding(.bottom, 8)

                                        Text("Combinação:")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))

                                        Text(buscarDescricaoCombinada(nome1: firstCard.name, nome2: secondCard.name))
                                            .foregroundColor(.white.opacity(0.9))
                                            .font(.body)
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.2))
                                    .cornerRadius(8)
                                } else {
                                    Text("Combinação \(pairIndex + 1): Cartas não selecionadas")
                                        .foregroundColor(.white.opacity(0.5))
                                }
                            }
                            Divider().background(Color.white.opacity(0.5))
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            getCards()
        }
    }
    
    func getCards() {
        do {
            combinedCards = try CombinedCards().getCombinedCards()
        } catch {
            print("Erro ao carregar as cartas combinadas: \(error)")
        }
    }
    
    func buscarDescricaoCombinada(nome1: String, nome2: String) -> String {
        let nomeCombinado = "\(nome1), \(nome2)"
        if let cartaCombinada = combinedCards.first(where: { $0.number.lowercased() == nomeCombinado.lowercased() }) {
            return cartaCombinada.description
        } else {
            return "Nenhuma combinação encontrada para \(nomeCombinado)."
        }
    }
}

#Preview {
    AllCardsReadingView(selectedCardNumbers: [:], allCards: [], sectionTitles: [])
}
