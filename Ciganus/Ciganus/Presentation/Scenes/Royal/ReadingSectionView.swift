//
//  ReadingSectionView.swift
//  Ciganus
//
//  Created by Fernando Marins on 26/11/25.
//

import SwiftUI

struct ReadingSectionView: View {
    let title: String
    let sectionIndex: Int
    let selectedCardNumbers: [Int: String]
    let allCards: [Card]
    let combinedCards: [CombinedCardModel]
    let aiInterpretation: String?
    let isLoadingAI: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.cyan)
                .padding(.bottom, 4)
            
            if isLoadingAI {
                // Loading state
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .cyan))
                    Text("Gerando interpretação com IA...")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else if let interpretation = aiInterpretation {
                // AI-generated interpretation
                Text(interpretation)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
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
            } else {
                // Fallback: show individual combinations
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
}
