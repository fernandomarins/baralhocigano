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

struct CardNumberInputView: View {
    @Binding var cardNumber: String
    let isDuplicate: Bool
    let isFocused: Bool
    let onFocusChange: (Bool) -> Void
    @FocusState private var textFieldFocused: Bool

    private var borderColor: Color {
        isDuplicate ? Color.red : Color.blue
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(borderColor, lineWidth: isDuplicate ? 2 : 1)
            .background(Color.clear)
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                TextField("", text: $cardNumber)
                    .focused($textFieldFocused)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(8)
                    .onChange(of: textFieldFocused) { _, newValue in
                        onFocusChange(newValue)
                    }
            )
    }
}

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
