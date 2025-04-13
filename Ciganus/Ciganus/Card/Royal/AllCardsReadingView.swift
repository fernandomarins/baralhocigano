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

                            ForEach(0..<6, id: \.self) { cardIndexInSection in
                                let globalIndex = getGlobalIndex(for: sectionIndex, row: cardIndexInSection)
                                if let card = getCard(at: globalIndex), let cardNumberString = selectedCardNumbers[globalIndex] {
                                    VStack(alignment: .leading) {
                                        Text("Carta \(cardNumberString): \(card.name)")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .bold()
                                            .padding(.bottom, 8)
                                        Text("\(card.generalMeanings)")
                                            .foregroundColor(.white.opacity(0.8))
                                            .font(.body)
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.2))
                                    .cornerRadius(8)
                                } else if let cardNumberString = selectedCardNumbers[globalIndex], !cardNumberString.isEmpty {
                                    Text("Posição \(cardNumberString): Carta não encontrada")
                                        .foregroundColor(.red)
                                } else {
                                    Text("Posição \(globalIndex + 1): Aguardando seleção")
                                        .foregroundColor(.white)
                                }
                            }
                            Divider().background(Color.white.opacity(0.5))
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    AllCardsReadingView(selectedCardNumbers: [:], allCards: [], sectionTitles: [])
}
