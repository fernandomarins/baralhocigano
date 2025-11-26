//
//  AddReadingView.swift
//  Ciganus
//
//  Created by Fernando Marins on 26/11/25.
//

import SwiftUI

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
