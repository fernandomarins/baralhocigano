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
    @State private var isExporting = false

    var exportableText: String {
        "Interpretação da Leitura \(readingType.rawValue)\n\n" +
        cards.chunked(by: 2).enumerated().map { i, group in
            let names = group.map { "\($0.number) - \($0.name)" }.joined(separator: " e ")
            return "Cartas \(i * 2 + 1) e \(i * 2 + 2): \(names)\n\(interpretations[safe: i] ?? "Carregando interpretação...")\n\n"
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

                        ForEach(cards.chunked(by: 2).indices, id: \.self) { index in
                            if let group = cards.chunked(by: 2)[safe: index] {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        ForEach(group.indices, id: \.self) { cardIndex in
                                            if let card = group[safe: cardIndex] {
                                                Text("\(Int(card.number) ?? 0) - \(card.name)")
                                                    .font(.headline)
                                                    .foregroundColor(.cyan)
                                                if cardIndex < group.count - 1 {
                                                    Text("&")
                                                        .foregroundColor(.white.opacity(0.5))
                                                }
                                            }
                                        }
                                    }
                                    .padding(.bottom, 4)
                                    
                                    Divider()
                                        .background(Color.white.opacity(0.2))

                                    Text(interpretations[safe: index] ?? "Carregando interpretação...")
                                        .foregroundColor(.white.opacity(0.9))
                                        .font(.body)
                                        .lineSpacing(4)
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
            interpretations = Array(repeating: "Erro ao carregar interpretação.", count: 3)
        }
    }

    func loadInterpretations() {
        interpretations = cards
            .chunked(by: 2)
            .prefix(3)
            .enumerated()
            .map { index, group in
                let cardNames = group.map(\.name).joined(separator: ", ")
                let interpretation = combinedCards
                    .first { $0.number.lowercased() == cardNames.lowercased() }?
                    .description ?? "Combinação não encontrada para: \(cardNames)"
                
                print("[\(index)] \(cardNames): \(interpretation)")
                return interpretation
            }
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
        DailyInterpretationView(cards: [
            CardInfo(number: "1", name: "Cavaleiro"),
            CardInfo(number: "2", name: "Trevo"),
            CardInfo(number: "3", name: "Navio"),
            CardInfo(number: "4", name: "Casa"),
            CardInfo(number: "5", name: "Árvore"),
            CardInfo(number: "6", name: "Nuvens")
        ], readingType: .daily)
        .preferredColorScheme(.dark)
    }
}
