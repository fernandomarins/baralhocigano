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
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("\(Int(pair.card1.number) ?? 0) - \(pair.card1.name)")
                                        .font(.headline)
                                        .foregroundColor(.cyan)
                                    Text("e")
                                        .foregroundColor(.white.opacity(0.5))
                                    Text("\(Int(pair.card2.number) ?? 0) - \(pair.card2.name)")
                                        .font(.headline)
                                        .foregroundColor(.cyan)
                                }
                                .padding(.bottom, 4)
                                
                                Divider()
                                    .background(Color.white.opacity(0.2))

                                Text(interpretations[safe: index] ?? "Carregando interpretação...")
                                    .foregroundColor(.white.opacity(0.9))
                                    .font(.body)
                                    .lineSpacing(4)
                                
                                if let hidden = pair.hiddenCard, let fullCard = getFullCard(for: hidden) {
                                    Divider()
                                        .background(Color.white.opacity(0.1))
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            Text("Carta Oculta:")
                                                .font(.headline)
                                                .foregroundColor(.purple)
                                            Text("\(Int(hidden.number) ?? 0) - \(hidden.name)")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                        }
                                        .padding(.bottom, 4)
                                        
                                        Group {
                                            SectionView(title: "Palavras-chave", content: fullCard.keywords)
                                            SectionView(title: "Significados gerais", content: fullCard.generalMeanings)
                                            SectionView(title: "Influência Astrológica", content: fullCard.astrologicalInfluence)
                                            SectionView(title: "Figura Arquétipica", content: fullCard.archetypeFigure)
                                            SectionView(title: "Plano Espiritual", content: fullCard.spiritualPlane)
                                            SectionView(title: "Plano Mental", content: fullCard.mentalPlane)
                                            SectionView(title: "Plano Emocional", content: fullCard.emotionalPlane)
                                            SectionView(title: "Plano Material", content: fullCard.materialPlane)
                                            SectionView(title: "Plano Físico (doenças)", content: fullCard.physicalPlane)
                                            SectionView(title: "Pontos Positivos", content: fullCard.positivePoints)
                                            SectionView(title: "Pontos Negativos", content: fullCard.negativePoints)
                                            
                                            if !fullCard.yearPrediction.isEmpty {
                                                SectionView(title: "Previsões para o Ano", content: fullCard.yearPrediction)
                                            }
                                            
                                            if !fullCard.time.isEmpty {
                                                SectionView(title: "Tempo", content: fullCard.time)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
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

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No need to update
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
