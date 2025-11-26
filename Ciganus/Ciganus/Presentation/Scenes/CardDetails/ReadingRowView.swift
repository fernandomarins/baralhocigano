//
//  ReadingRowView.swift
//  Ciganus
//
//  Created by Fernando Marins on 26/11/25.
//

import SwiftUI

struct ReadingRowView: View {
    let reading: Reading
    let combinedCards: [CombinedCardModel]
    let allCards: [Card]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(reading.type.rawValue.capitalized)
                    .font(.headline)
                    .foregroundColor(.cyan)
                Spacer()
                Text(reading.formattedDate)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
            
            ForEach(reading.pairs) { pair in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("\(Int(pair.card1.number) ?? 0) - \(pair.card1.name)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .bold()
                        Spacer()
                        Text("\(Int(pair.card2.number) ?? 0) - \(pair.card2.name)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .bold()
                    }
                    
                    if let description = getCombinationDescription(for: pair) {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(3)
                            .padding(8)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                    }
                    
                    if let hiddenCard = pair.hiddenCard {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Oculto: \(Int(hiddenCard.number) ?? 0) - \(hiddenCard.name)")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .bold()
                            
                            if let description = getSingleCardDescription(for: hiddenCard) {
                                Text(description)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                    .lineLimit(2)
                            }
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.vertical, 4)
                
                if pair.id != reading.pairs.last?.id {
                    Divider().background(Color.white.opacity(0.1))
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
    
    func getCombinationDescription(for pair: ReadingPair) -> String? {
        let cardNames = "\(pair.card1.name), \(pair.card2.name)"
        return combinedCards.first { $0.number.lowercased() == cardNames.lowercased() }?.description
    }
    
    func getSingleCardDescription(for card: CardInfo) -> String? {
        return allCards.first { $0.number == card.number }?.keywords
    }
}
