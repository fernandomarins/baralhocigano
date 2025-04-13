//
//  AllCardsView.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import SwiftUI

struct AllCardsView: View {
    let allCards: [Card]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 6)
    @State private var cardNumbers: [Int: String] = [:]
    @State private var highlightedDuplicates: Set<Int> = []
    @FocusState private var focusedFieldIndex: Int?
    @State private var isReadingViewPresented = false

    let sectionTitles = [
        "Influências passadas/paralelas",
        "Influências presentes",
        "Influências exteriores",
        "Influências do futuro imediato",
        "Possibilidades para o futuro",
        "Resultados e conseqüências futuras"
    ]

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
                    VStack(alignment: .leading) {
                        ForEach(0..<sectionTitles.count, id: \.self) { sectionIndex in
                            Text(sectionTitles[sectionIndex])
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.top)
                                .padding(.leading)

                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(0..<6, id: \.self) { cardIndexInSection in
                                    let globalIndex = sectionIndex * 6 + cardIndexInSection
                                    CardNumberInputView(
                                        cardNumber: Binding(
                                            get: { cardNumbers[globalIndex] ?? "" },
                                            set: { newValue in
                                                if newValue.isEmpty || (Int(newValue) != nil && (1...36).contains(Int(newValue)!)) {
                                                    cardNumbers[globalIndex] = newValue
                                                    validateDuplicates()
                                                }
                                            }
                                        ),
                                        isDuplicate: highlightedDuplicates.contains(globalIndex),
                                        isFocused: focusedFieldIndex == globalIndex,
                                        onFocusChange: { isFocused in
                                            focusedFieldIndex = isFocused ? globalIndex : nil
                                        }
                                    )
                                    .frame(height: 60)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom)
                }
                .navigationTitle("Mesa Real Kármica")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isReadingViewPresented = true
                        } label: {
                            Text("Leitura")
                                .foregroundColor(.white)
                        }
                    }
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Concluir") {
                            dismissKeyboard()
                        }
                    }
                }
                .sheet(isPresented: $isReadingViewPresented) {
                    AllCardsReadingView(selectedCardNumbers: cardNumbers, allCards: allCards, sectionTitles: sectionTitles)
                }
            }
        }
    }

    func validateDuplicates() {
        var seenNumbers: [String: [Int]] = [:]
        var newDuplicates: Set<Int> = []

        for (index, number) in cardNumbers {
            if !number.isEmpty {
                if var indices = seenNumbers[number] {
                    indices.append(index)
                    seenNumbers[number] = indices
                    newDuplicates.insert(index)
                    for seenIndex in indices {
                        newDuplicates.insert(seenIndex)
                    }
                } else {
                    seenNumbers[number] = [index]
                }
            }
        }
        highlightedDuplicates = newDuplicates
    }
}

#if canImport(UIKit)
extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

#Preview {
    AllCardsView(allCards: [])
}
