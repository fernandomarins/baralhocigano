//
//  DailyReadingView.swift
//  Ciganus
//
//  Created by Fernando Marins on 12/04/25.
//

import SwiftUI

struct DailyReadingView: View {
    @State private var showingAddCardView = false
    @State private var readings: [Reading] = []
    @State private var selectedReading: Reading?
    @State private var selectedReadingType: ReadingType?
    @State private var selectedReadingCards: [CardInfo] = []
    @State private var showingInterpretationView = false
    @State private var combinedCards: [CombinedCardModel] = []

    var body: some View {
        ZStack {
            CosmicBackground()

            VStack {
                if readings.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "sparkles.rectangle.stack")
                            .font(.system(size: 60))
                            .foregroundColor(.cyan.opacity(0.8))
                        Text("Nenhuma leitura ainda")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Toque no + para adicionar sua primeira leitura")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(readings.sorted(by: { $0.date > $1.date })) { reading in
                            ReadingRowView(reading: reading, combinedCards: combinedCards)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    selectedReading = reading
                                    selectedReadingType = reading.type
                                }
                        }
                        .onDelete(perform: deleteReading)
                    }
                    .listStyle(.plain)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .sheet(item: $selectedReading) { reading in
                        DailyInterpretationView(cards: reading.cards, readingType: reading.type)
                    }
                }

                Spacer()

                Button {
                    showingAddCardView = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title.weight(.bold))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.cyan, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .shadow(color: .cyan.opacity(0.5), radius: 10, x: 0, y: 0)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.bottom)
            }
            .padding()
            .navigationTitle("Leituras")
            .sheet(isPresented: $showingAddCardView) {
                AddReadingView(onReadingAdded: { newReading in
                    readings.append(newReading)
                })
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            loadCombinedCards()
        }
    }

    func deleteReading(at offsets: IndexSet) {
        readings.remove(atOffsets: offsets)
    }
    
    func loadCombinedCards() {
        do {
            combinedCards = try CombinedCards().getCombinedCards()
        } catch {
            print("Erro ao carregar cartas combinadas: \(error)")
        }
    }
}

struct ReadingRowView: View {
    let reading: Reading
    let combinedCards: [CombinedCardModel]

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
            
            ForEach(reading.cards.chunked(by: 2), id: \.self) { group in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        ForEach(group.indices, id: \.self) { index in
                            let card = group[index]
                            Text("\(Int(card.number) ?? 0) - \(card.name)")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .bold()
                            if index < group.count - 1 {
                                Spacer()
                            }
                        }
                    }
                    
                    if let description = getCombinationDescription(for: group) {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(3)
                            .padding(8)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                    }
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
    
    func getCombinationDescription(for cards: [CardInfo]) -> String? {
        let cardNames = cards.map(\.name).joined(separator: ", ")
        return combinedCards.first { $0.number.lowercased() == cardNames.lowercased() }?.description
    }
}

struct AddReadingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isDaily = true
    @State private var isWeekly = false
    @State private var isMonthly = false
    @State private var isClient = false
    @State private var cardPairs: [[String]] = [["", ""]]
    @State private var showingCardNumberAlert = false
    @State private var alertMessage = ""

    var onReadingAdded: (Reading) -> Void

    var body: some View {
        NavigationView {
            ZStack {
                CosmicBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Tipo de Leitura
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tipo de Leitura")
                                .font(.headline)
                                .foregroundColor(.cyan)
                            
                            VStack(spacing: 10) {
                                Toggle(isOn: $isDaily) {
                                    Text("Diária")
                                        .foregroundColor(.white)
                                }
                                .onChange(of: isDaily) { _, newValue in
                                    if newValue { resetToggles(except: .daily) }
                                    else if !anyToggleOn() { isDaily = true }
                                }
                                Divider().background(Color.white.opacity(0.1))
                                Toggle(isOn: $isWeekly) {
                                    Text("Semanal")
                                        .foregroundColor(.white)
                                }
                                .onChange(of: isWeekly) { _, newValue in
                                    if newValue { resetToggles(except: .weekly) }
                                    else if !anyToggleOn() { isWeekly = true }
                                }
                                Divider().background(Color.white.opacity(0.1))
                                Toggle(isOn: $isMonthly) {
                                    Text("Mensal")
                                        .foregroundColor(.white)
                                }
                                .onChange(of: isMonthly) { _, newValue in
                                    if newValue { resetToggles(except: .monthly) }
                                    else if !anyToggleOn() { isMonthly = true }
                                }
                                Divider().background(Color.white.opacity(0.1))
                                Toggle(isOn: $isClient) {
                                    Text("Cliente")
                                        .foregroundColor(.white)
                                }
                                .onChange(of: isClient) { _, newValue in
                                    if newValue { resetToggles(except: .client) }
                                    else if !anyToggleOn() { isClient = true }
                                }
                            }
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                        
                        // Cartas
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Cartas")
                                .font(.headline)
                                .foregroundColor(.cyan)
                            
                            ForEach(cardPairs.indices, id: \.self) { index in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Combinação \(index + 1)")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                        Spacer()
                                        if cardPairs.count > 1 {
                                            Button {
                                                removeCardPair(at: index)
                                            } label: {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.red.opacity(0.8))
                                            }
                                        }
                                    }
                                    
                                    HStack(spacing: 12) {
                                        ZStack {
                                            if cardPairs[index][0].isEmpty {
                                                Text("Carta 1")
                                                    .foregroundColor(.white.opacity(0.5))
                                            }
                                            TextField("", text: $cardPairs[index][0])
                                                .keyboardType(.numberPad)
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.white)
                                        }
                                        .padding()
                                        .background(Color.black.opacity(0.3))
                                        .cornerRadius(8)
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.2), lineWidth: 1))
                                        
                                        ZStack {
                                            if cardPairs[index][1].isEmpty {
                                                Text("Carta 2")
                                                    .foregroundColor(.white.opacity(0.5))
                                            }
                                            TextField("", text: $cardPairs[index][1])
                                                .keyboardType(.numberPad)
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.white)
                                        }
                                        .padding()
                                        .background(Color.black.opacity(0.3))
                                        .cornerRadius(8)
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.2), lineWidth: 1))
                                    }
                                }
                                .padding()
                                .background(Color.black.opacity(0.2))
                                .cornerRadius(12)
                            }
                            
                            Button {
                                cardPairs.append(["", ""])
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Adicionar Mais Cartas")
                                }
                                .foregroundColor(.cyan)
                                .padding(.top, 8)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Nova Leitura")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Adicionar") {
                        addReading()
                    }
                    .foregroundColor(.cyan)
                    .fontWeight(.bold)
                }
            }
            .alert(isPresented: $showingCardNumberAlert) {
                Alert(title: Text("Atenção"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    enum ReadingTypeToggle { case daily, weekly, monthly, client }
    
    func resetToggles(except type: ReadingTypeToggle) {
        if type != .daily { isDaily = false }
        if type != .weekly { isWeekly = false }
        if type != .monthly { isMonthly = false }
        if type != .client { isClient = false }
    }
    
    func anyToggleOn() -> Bool {
        return isDaily || isWeekly || isMonthly || isClient
    }

    func addReading() {
        if areCardNumbersValid() {
            var readingType: ReadingType = .daily
            if isWeekly { readingType = .weekly }
            else if isMonthly { readingType = .monthly }
            else if isClient { readingType = .client }

            var validCards: [CardInfo] = []
            var allValid = true

            for pair in cardPairs {
                for number in pair {
                    if let name = Source.shared.name(for: number) {
                        validCards.append(CardInfo(number: number, name: name))
                    } else if !number.isEmpty {
                        alertMessage = "Número de carta inválido: \(number). Por favor, verifique os números."
                        showingCardNumberAlert = true
                        allValid = false
                        break
                    }
                }
                if !allValid { break }
            }

            if allValid {
                let newReading = Reading(type: readingType, cards: validCards.filter { !$0.number.isEmpty }, date: Date())
                onReadingAdded(newReading)
                dismiss()
            }
        } else {
            alertMessage = "Por favor, preencha o número de todas as cartas."
            showingCardNumberAlert = true
        }
    }

    func areCardNumbersValid() -> Bool {
        for pair in cardPairs {
            for number in pair {
                if !number.isEmpty, Source.shared.name(for: number) == nil {
                    return false
                }
            }
        }
        return true
    }

    func removeCardPair(at index: Int) {
        if cardPairs.count > 1 {
            cardPairs.remove(at: index)
        }
    }
}

struct Reading: Identifiable {
    let id = UUID()
    let type: ReadingType
    let cards: [CardInfo]
    let date: Date

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct CardInfo: Hashable {
    var number: String
    var name: String
}

enum ReadingType: String, CaseIterable, Identifiable {
    var id: Self { self }
    case client = "Cliente"
    case daily = "Diária"
    case weekly = "Semanal"
    case monthly = "Mensal"
}

extension Array {
    func chunked(by size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

struct DailyReadingView_Previews: PreviewProvider {
    static var previews: some View {
        DailyReadingView()
            .preferredColorScheme(.dark)
    }
}
