//
//  DailyInterpretationView.swift
//  Ciganus
//
//  Created by Fernando Marins on 12/04/25.
//

import SwiftUI

struct DailyInterpretationView: View {
    let cards: [CardInfo]
    let readingType: ReadingType
    @State private var combinedCards: [CombinedCardModel] = []
    @State private var interpretations: [String] = Array(repeating: "", count: 3)

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.indigo, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack {
                    Text("Interpretação da Leitura \(readingType.rawValue)")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()

                    ForEach(cards.chunked(by: 2).indices, id: \.self) { index in
                        if let group = cards.chunked(by: 2)[safe: index] {
                            HStack {
                                ForEach(group.indices, id: \.self) { cardIndex in
                                    if let card = group[safe: cardIndex] {
                                        Text("\(Int(card.number) ?? 0) - \(card.name)")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(.vertical, 5)

                            Text(interpretations[safe: index] ?? "Carregando interpretação...")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .padding(.bottom)
                        }
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            getCombinedCards()
        }
    }

    func getCombinedCards() {
        do {
            combinedCards = try CombinedCards().getCombinedCards()
            loadInterpretations()
        } catch {
            print("Erro ao carregar as cartas combinadas: \(error)")
            interpretations = Array(repeating: "Erro ao carregar interpretação.", count: 3)
        }
    }

    func loadInterpretations() {
        for i in 0..<3 {
            if let group = cards.chunked(by: 2)[safe: i] {
                let cardNames = group.map { $0.name }.joined(separator: ", ")

                if let foundCard = combinedCards.first(where: {
                    return $0.number.lowercased() == cardNames.lowercased()
                }) {
                    DispatchQueue.main.async {
                        interpretations[i] = foundCard.description
                        print("Descrição para \(cardNames): \(foundCard.description)")
                    }
                } else {
                    DispatchQueue.main.async {
                        interpretations[i] = "Combinação não encontrada para: \(cardNames)"
                        print("Combinação não encontrada para: \(cardNames)")
                    }
                }
            }
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct DailyInterpretationView_Previews: PreviewProvider {
    static var previews: some View {
        DailyInterpretationView(cards: [
            CardInfo(number: "1", name: "Cavaleiro"),
            CardInfo(number: "2", name: "Trevo"),
            CardInfo(number: "3", name: "Navio"),
            CardInfo(number: "4", name: "Casa"),
            CardInfo(number: "5", name: "Árvore"),
            CardInfo(number: "6", name: "Nuvens")
        ], readingType: .daily)
    }
}
