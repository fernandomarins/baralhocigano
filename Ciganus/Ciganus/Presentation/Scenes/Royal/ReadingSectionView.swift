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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.cyan)
                .padding(.bottom, 4)
            
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
