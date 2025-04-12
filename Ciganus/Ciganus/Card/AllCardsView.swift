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
    
    @State private var cardNumbers: [String] = Array(1...36).map { String($0) }
    @State private var selectedCard: Card? = nil
    @State private var isCardViewPresented = false

    let sectionTitles = [
        "Influências passadas/paralelas",
        "Influências presentes",
        "Influências exteriores",
        "Influências do futuro imediato",
        "Possibilidades para o futuro",
        "Resultados e conseqüências futuras"
    ]

    func getCard(at globalIndex: Int) -> Card? {
        if globalIndex < cardNumbers.count,
           let cardNumber = Int(cardNumbers[globalIndex]),
           let card = allCards.first(where: { Int($0.number) == cardNumber }) {
            return card
        }
        return nil
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(0..<sectionTitles.count, id: \.self) { sectionIndex in
                        Text(sectionTitles[sectionIndex])
                            .font(.headline)
                            .padding(.top)
                            .padding(.leading)

                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(0..<6, id: \.self) { cardIndexInSection in
                                let globalIndex = sectionIndex * 6 + cardIndexInSection
                                if getCard(at: globalIndex) != nil {
                                    CardNumberView(
                                        cardNumberText: $cardNumbers[globalIndex],
                                        allCards: allCards,
                                        onCardTap: { selectedCard in
                                            self.selectedCard = selectedCard
                                            isCardViewPresented = true
                                        }
                                    )
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.1))
                                        .aspectRatio(1, contentMode: .fit)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("Mesa Real Kármica")
            .sheet(isPresented: $isCardViewPresented) {
                if let card = selectedCard {
                    CardView(card: card, fromAllCard: true)
                        .presentationDetents([.medium, .large])
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Concluir") {
                        dismissKeyboard()
                    }
                }
            }
        }
    }
}

struct CardNumberView: View {
    @Binding var cardNumberText: String
    let allCards: [Card]
    let onCardTap: (Card) -> Void

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(isTextFieldFocused ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                TextField("", text: $cardNumberText)
                    .focused($isTextFieldFocused)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(8)
                    .onSubmit {
                        if let cardNumber = Int(cardNumberText),
                           let card = allCards.first(where: { Int($0.number) == cardNumber }) {
                            onCardTap(card)
                        }
                        isTextFieldFocused = false
                    }
            )
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
