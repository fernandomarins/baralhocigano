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

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            isExporting = true
                        } label: {
                            Image(systemName: "square.and.arrow.up.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.purple)
                                .frame(width: 60, height: 60)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
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
    }
}
