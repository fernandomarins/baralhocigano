//
//  DailyInterpretationView.swift
//  Ciganus
//
//  Created by Fernando Marins on 12/04/25.
//

import SwiftUI
import SwiftData

struct DailyInterpretationView: View {
    let pairs: [ReadingPair]
    let readingType: ReadingType
    @Query private var allCards: [Card]
    @State private var combinedCards: [CombinedCardModel] = []
    @State private var interpretations: [String] = []
    @State private var isExporting = false

    var exportableText: String {
        "Interpretação da Leitura \(readingType.rawValue)\n\n" +
        pairs.enumerated().map { i, pair in
            let names = "\(pair.card1.number) - \(pair.card1.name) e \(pair.card2.number) - \(pair.card2.name)"
            var text = "Par \(i + 1): \(names)\n\(interpretations[safe: i] ?? "Carregando interpretação...")\n"
            if let hidden = pair.hiddenCard, let fullCard = getFullCard(for: hidden) {
                text += "\nCarta Oculta: \(hidden.number) - \(hidden.name)\n"
                text += "Palavras-chave: \(fullCard.keywords)\n"
                text += "Significados gerais: \(fullCard.generalMeanings)\n"
                // Add other fields if needed for export
            }
            return text + "\n"
        }.joined()
    }

    var body: some View {
        NavigationView {
            ZStack {
                CosmicBackground()

                ScrollView {
                    VStack(spacing: 24) {
                        Text("Interpretação da Leitura \(readingType.rawValue)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .shadow(color: .purple.opacity(0.5), radius: 10)
                            .padding(.top)

                        ForEach(pairs.indices, id: \.self) { index in
                            let pair = pairs[index]
                            let hiddenCard = pair.hiddenCard.flatMap { getFullCard(for: $0) }
                            InterpretationRowView(
                                pair: pair,
                                interpretation: interpretations[safe: index] ?? "Carregando interpretação...",
                                fullHiddenCard: hiddenCard
                            )
                        }
                        
                        Spacer(minLength: 80)
                    }
                    .padding()
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            isExporting = true
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2.weight(.bold))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.purple, .blue],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                )
                                .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 0)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                getCombinedCards()
            }
            .sheet(isPresented: $isExporting) {
                ShareSheet(items: [exportableText])
            }
        }
    }

    func getCombinedCards() {
        do {
            combinedCards = try CombinedCards().getCombinedCards()
            loadInterpretations()
        } catch {
            print("Erro ao carregar as cartas combinadas: \(error)")
            interpretations = Array(repeating: "Erro ao carregar interpretação.", count: pairs.count)
        }
    }

    func loadInterpretations() {
        interpretations = pairs.enumerated().map { index, pair in
            let cardNames = "\(pair.card1.name), \(pair.card2.name)"
            let interpretation = combinedCards
                .first { $0.number.lowercased() == cardNames.lowercased() }?
                .description ?? "Combinação não encontrada para: \(cardNames)"
            
            return interpretation
        }
    }
    
    func getFullCard(for info: CardInfo) -> Card? {
        return allCards.first { $0.number == info.number }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct DailyInterpretationView_Previews: PreviewProvider {
    static var previews: some View {
        DailyInterpretationView(pairs: [
            ReadingPair(
                card1: CardInfo(number: "1", name: "Cavaleiro"),
                card2: CardInfo(number: "2", name: "Trevo"),
                hiddenCard: CardInfo(number: "3", name: "Navio")
            )
        ], readingType: .daily)
        .preferredColorScheme(.dark)
    }
}
