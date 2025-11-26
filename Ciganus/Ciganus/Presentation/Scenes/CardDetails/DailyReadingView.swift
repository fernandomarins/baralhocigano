//
//  DailyReadingView.swift
//  Ciganus
//
//  Created by Fernando Marins on 12/04/25.
//

import SwiftUI
import SwiftData

struct DailyReadingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Reading.date, order: .reverse) private var readings: [Reading]
    @Query private var allCards: [Card]
    
    @State private var showingAddCardView = false
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
                        ForEach(readings) { reading in
                            ReadingRowView(reading: reading, combinedCards: combinedCards, allCards: allCards)
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
                        DailyInterpretationView(pairs: reading.pairs, readingType: reading.type)
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
                    modelContext.insert(newReading)
                })
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            loadCombinedCards()
        }
    }

    func deleteReading(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(readings[index])
        }
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

struct AddReadingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isDaily = true
    @State private var isWeekly = false
    @State private var isMonthly = false
    @State private var isClient = false
    
    struct InputPair: Identifiable {
        var id = UUID()
        var card1: String = ""
        var card2: String = ""
        var hidden: String = ""
    }
    
    @State private var inputPairs: [InputPair] = [InputPair()]
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
                            
                            VStack(spacing: 5) {
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
                            
                            ForEach($inputPairs) { $pair in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Combinação")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                        Spacer()
                                        if inputPairs.count > 1 {
                                            Button {
                                                if let index = inputPairs.firstIndex(where: { $0.id == pair.id }) {
                                                    inputPairs.remove(at: index)
                                                }
                                            } label: {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.red.opacity(0.8))
                                            }
                                        }
                                    }
                                    
                                    HStack(spacing: 12) {
                                        ZStack {
                                            if pair.card1.isEmpty {
                                                Text("Carta 1")
                                                    .foregroundColor(.white.opacity(0.5))
                                            }
                                            TextField("", text: $pair.card1)
                                                .keyboardType(.numberPad)
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.white)
                                        }
                                        .padding()
                                        .background(Color.black.opacity(0.3))
                                        .cornerRadius(8)
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.2), lineWidth: 1))
                                        
                                        ZStack {
                                            if pair.card2.isEmpty {
                                                Text("Carta 2")
                                                    .foregroundColor(.white.opacity(0.5))
                                            }
                                            TextField("", text: $pair.card2)
                                                .keyboardType(.numberPad)
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.white)
                                        }
                                        .padding()
                                        .background(Color.black.opacity(0.3))
                                        .cornerRadius(8)
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.2), lineWidth: 1))
                                    }
                                    
                                    // Hidden Card Input per pair
                                    ZStack {
                                        if pair.hidden.isEmpty {
                                            Text("Oculta (Opcional)")
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                        TextField("", text: $pair.hidden)
                                            .keyboardType(.numberPad)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.purple.opacity(0.3), lineWidth: 1))
                                }
                                .padding()
                                .background(Color.black.opacity(0.2))
                                .cornerRadius(12)
                            }
                            
                            Button {
                                inputPairs.append(InputPair())
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

            var validPairs: [ReadingPair] = []
            var allValid = true

            for input in inputPairs {
                guard let name1 = Source.shared.name(for: input.card1),
                      let name2 = Source.shared.name(for: input.card2) else {
                    alertMessage = "Número de carta inválido."
                    showingCardNumberAlert = true
                    allValid = false
                    break
                }
                
                var hiddenCard: CardInfo? = nil
                if !input.hidden.isEmpty {
                    if let hiddenName = Source.shared.name(for: input.hidden) {
                        hiddenCard = CardInfo(number: input.hidden, name: hiddenName)
                    } else {
                        alertMessage = "Número da carta oculta inválido: \(input.hidden)."
                        showingCardNumberAlert = true
                        allValid = false
                        break
                    }
                }
                
                let pair = ReadingPair(
                    card1: CardInfo(number: input.card1, name: name1),
                    card2: CardInfo(number: input.card2, name: name2),
                    hiddenCard: hiddenCard
                )
                validPairs.append(pair)
            }

            if allValid {
                let newReading = Reading(type: readingType, pairs: validPairs, date: Date())
                onReadingAdded(newReading)
                dismiss()
            }
        } else {
            alertMessage = "Por favor, preencha o número de todas as cartas principais."
            showingCardNumberAlert = true
        }
    }

    func areCardNumbersValid() -> Bool {
        for pair in inputPairs {
            if pair.card1.isEmpty || pair.card2.isEmpty { return false }
            if Source.shared.name(for: pair.card1) == nil { return false }
            if Source.shared.name(for: pair.card2) == nil { return false }
        }
        return true
    }
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
            .modelContainer(for: Reading.self, inMemory: true)
    }
}
