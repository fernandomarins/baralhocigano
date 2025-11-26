//
//  AllCardsView.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import SwiftUI

struct AllCardsView: View {
    let allCards: [Card]
    
    @State private var cardNumbers: [Int: String] = [:]
    @State private var highlightedDuplicates: Set<Int> = []
    @State private var isReadingViewPresented = false
    @FocusState private var focusedField: Int?

    private let sectionTitles = [
        "Influências passadas/paralelas",
        "Influências presentes",
        "Influências exteriores",
        "Influências do futuro imediato",
        "Possibilidades para o futuro",
        "Resultados e conseqüências futuras"
    ]
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 6)

    var body: some View {
        NavigationView {
            ZStack {
                CosmicBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(0..<sectionTitles.count, id: \.self) { sectionIndex in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(sectionTitles[sectionIndex])
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)

                                LazyVGrid(columns: columns, spacing: 8) {
                                    ForEach(0..<6, id: \.self) { cardIndex in
                                        let globalIndex = sectionIndex * 6 + cardIndex
                                        
                                        CardNumberInputView(
                                            cardNumber: Binding(
                                                get: { cardNumbers[globalIndex] ?? "" },
                                                set: { newValue in
                                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                                    let limited = String(filtered.prefix(2))
                                                    
                                                    if limited.isEmpty || (Int(limited) != nil && (1...36).contains(Int(limited)!)) {
                                                        cardNumbers[globalIndex] = limited
                                                        validateDuplicates()
                                                        
                                                        // Auto-advance focus if 2 digits are entered
                                                        if limited.count == 2 {
                                                            if globalIndex < 35 {
                                                                focusedField = globalIndex + 1
                                                            } else {
                                                                focusedField = nil
                                                            }
                                                        }
                                                    }
                                                }
                                            ),
                                            isDuplicate: highlightedDuplicates.contains(globalIndex),
                                            isFocused: focusedField == globalIndex,
                                            onFocusChange: { focused in
                                                if focused {
                                                    focusedField = globalIndex
                                                }
                                            }
                                        )
                                        .frame(height: 70)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .navigationTitle("Mesa Real Kármica")
                .preferredColorScheme(.dark)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Leitura") {
                            isReadingViewPresented = true
                        }
                        .foregroundColor(.white)
                    }
                }
                .sheet(isPresented: $isReadingViewPresented) {
                    AllCardsReadingView(
                        selectedCardNumbers: cardNumbers,
                        allCards: allCards,
                        sectionTitles: sectionTitles
                    )
                }
            }
        }
    }

    private func validateDuplicates() {
        var seenNumbers: [String: [Int]] = [:]
        var newDuplicates: Set<Int> = []

        for (index, number) in cardNumbers where !number.isEmpty {
            if var indices = seenNumbers[number] {
                indices.append(index)
                seenNumbers[number] = indices
                indices.forEach { newDuplicates.insert($0) }
            } else {
                seenNumbers[number] = [index]
            }
        }
        
        highlightedDuplicates = newDuplicates
    }
}

#Preview {
    AllCardsView(allCards: [])
}
