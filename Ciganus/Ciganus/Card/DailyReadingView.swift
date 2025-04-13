//
//  DailyReadingView.swift
//  Ciganus
//
//  Created by Fernando Marins on 12/04/25.
//

import SwiftUI

struct DailyReadingView: View {
    @State private var showingAddCardView = false
    @State private var readings: [Reading] = []
    @State private var selectedReading: Reading?
    @State private var selectedReadingType: ReadingType?
    @State private var selectedReadingCards: [CardInfo] = []
    @State private var showingInterpretationView = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.indigo]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack {
                    List {
                        ForEach(readings.sorted(by: { $0.date > $1.date })) { reading in
                            ReadingRowView(reading: reading)
                                .listRowBackground(Color.clear)
                                .onTapGesture {
                                    selectedReading = reading
                                    selectedReadingType = reading.type
                                }
                        }
                        .onDelete(perform: deleteReading)
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .sheet(item: $selectedReading) { reading in
                        DailyInterpretationView(cards: reading.cards, readingType: reading.type)
                    }

                    Spacer()

                    Button {
                        showingAddCardView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                            .frame(width: 60, height: 60)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
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
        }
    }

    func deleteReading(at offsets: IndexSet) {
        readings.remove(atOffsets: offsets)
    }
}

struct ReadingRowView: View {
    let reading: Reading

    var body: some View {
        VStack(alignment: .leading) {
            Text("Leitura \(reading.type.rawValue.capitalized)")
                .font(.headline)
                .padding(.bottom, 4)
            Text("Feita em: \(reading.formattedDate)")
                .font(.caption)
                .foregroundColor(.white)
                .padding(.bottom, 8)
            ForEach(reading.cards.chunked(by: 2), id: \.self) { group in
                HStack {
                    ForEach(group.indices, id: \.self) { index in
                        let card = group[index]
                        Text("\(Int(card.number) ?? 0) - \(card.name)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        if index < group.count - 1 {
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct AddReadingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isDaily = true
    @State private var isWeekly = false
    @State private var isMonthly = false
    @State private var cardPairs: [[String]] = [["", ""], ["", ""], ["", ""]]
    @State private var showingCardNumberAlert = false
    @State private var alertMessage = ""

    var onReadingAdded: (Reading) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Tipo de Leitura")) {
                    Toggle("Diária", isOn: $isDaily)
                        .onChange(of: isDaily) { _, newValue in
                            if newValue {
                                isWeekly = false
                                isMonthly = false
                            } else if !isWeekly && !isMonthly {
                                isDaily = true
                            }
                        }
                    Toggle("Semanal", isOn: $isWeekly)
                        .onChange(of: isWeekly) { _, newValue in
                            if newValue {
                                isDaily = false
                                isMonthly = false
                            } else if !isDaily && !isMonthly {
                                isWeekly = true
                            }
                        }
                    Toggle("Mensal", isOn: $isMonthly)
                        .onChange(of: isMonthly) { _, newValue in
                            if newValue {
                                isDaily = false
                                isWeekly = false
                            } else if !isDaily && !isWeekly {
                                isMonthly = true
                            }
                        }
                }

                Section(header: Text("Número das Cartas")) {
                    ForEach(cardPairs.indices, id: \.self) { index in
                        HStack {
                            Text("Combinação \(index + 1):")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            TextField("Carta 1", text: $cardPairs[index][0])
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                            TextField("Carta 2", text: $cardPairs[index][1])
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                            if cardPairs.count > 1 {
                                Button {
                                    removeCardPair(at: index)
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    Button {
                        cardPairs.append(["", ""])
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                            Text("Adicionar Mais Cartas")
                        }
                    }
                }
            }
            .navigationTitle("Nova Leitura")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Adicionar") {
                        if areCardNumbersValid() {
                            var readingType: ReadingType = .daily
                            if isWeekly {
                                readingType = .weekly
                            } else if isMonthly {
                                readingType = .monthly
                            }

                            var validCards: [CardInfo] = []
                            var allValid = true

                            for pair in cardPairs {
                                for number in pair {
                                    if let name = Source.shared.nomesDasCartas[number] {
                                        validCards.append(CardInfo(number: number, name: name))
                                    } else if !number.isEmpty {
                                        alertMessage = "Número de carta inválido: \(number). Por favor, verifique os números."
                                        showingCardNumberAlert = true
                                        allValid = false
                                        break
                                    }
                                }
                                if !allValid {
                                    break
                                }
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
                }
            }
            .alert(isPresented: $showingCardNumberAlert) {
                Alert(title: Text("Atenção"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func areCardNumbersValid() -> Bool {
        for pair in cardPairs {
            for number in pair {
                if !number.isEmpty, Source.shared.nomesDasCartas[number] == nil {
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
    }
}
