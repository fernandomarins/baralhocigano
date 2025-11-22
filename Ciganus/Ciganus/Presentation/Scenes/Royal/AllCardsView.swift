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
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.indigo]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

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
                                        
                                        TextField("", text: Binding(
                                            get: { cardNumbers[globalIndex] ?? "" },
                                            set: { newValue in
                                                let filtered = newValue.filter { "0123456789".contains($0) }
                                                let limited = String(filtered.prefix(2))
                                                
                                                if limited.isEmpty || (Int(limited) != nil && (1...36).contains(Int(limited)!)) {
                                                    cardNumbers[globalIndex] = limited
                                                    validateDuplicates()
                                                }
                                            }
                                        ))
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .font(.title3.weight(.bold))
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .strokeBorder(
                                                    highlightedDuplicates.contains(globalIndex) ? Color.red : Color.white,
                                                    lineWidth: highlightedDuplicates.contains(globalIndex) ? 2 : 1
                                                )
                                                .background(Color.white.opacity(0.2).cornerRadius(8))
                                        )
                                        .frame(height: 50)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .navigationTitle("Mesa Real Kármica")
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
