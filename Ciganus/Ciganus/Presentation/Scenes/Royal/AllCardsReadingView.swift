//
//  AllCardsReadingView.swift
//  Ciganus
//
//  Created by Fernando Marins on 13/04/25.
//

import SwiftUI

struct AllCardsReadingView: View {
    // MARK: - Properties
    let selectedCardNumbers: [Int: String]
    let allCards: [Card]
    let sectionTitles: [String]
    
    @State private var combinedCards: [CombinedCardModel] = []
    @State private var aiInterpretations: [Int: String] = [:] // sectionIndex -> interpretation
    @State private var loadingStates: [Int: Bool] = [:] // sectionIndex -> isLoading
    @State private var showingSaveAlert = false
    @State private var saveAlertMessage = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                CosmicBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        headerView
                        
                        ForEach(0..<sectionTitles.count, id: \.self) { sectionIndex in
                            if hasSectionCards(sectionIndex: sectionIndex) {
                                ReadingSectionView(
                                    title: sectionTitles[sectionIndex],
                                    sectionIndex: sectionIndex,
                                    selectedCardNumbers: selectedCardNumbers,
                                    allCards: allCards,
                                    combinedCards: combinedCards,
                                    aiInterpretation: aiInterpretations[sectionIndex],
                                    isLoadingAI: loadingStates[sectionIndex] ?? false
                                )
                                
                                if sectionIndex < sectionTitles.count - 1 {
                                    Divider().background(Color.white.opacity(0.5))
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        saveReading()
                    } label: {
                        Label("Salvar", systemImage: "square.and.arrow.down")
                    }
                    .foregroundColor(.white)
                    .disabled(aiInterpretations.isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fechar") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .alert("Leitura Salva", isPresented: $showingSaveAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(saveAlertMessage)
            }
        }
        .onAppear {
            loadCombinedCards()
            generateAIInterpretations()
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        Text("Leitura da Mesa Real Kármica")
            .font(.largeTitle)
            .bold()
            .foregroundColor(.white)
            .padding(.vertical)
    }
    
    // MARK: - Logic
    
    private func loadCombinedCards() {
        do {
            combinedCards = try CombinedCards().getCombinedCards()
        } catch {
            print("Erro ao carregar as cartas combinadas: \(error)")
        }
    }
    
    private func generateAIInterpretations() {
        // Check if Apple Intelligence is available
        if #available(iOS 26.0, *) {
            // Generate interpretations for each section
            for sectionIndex in 0..<sectionTitles.count {
                generateInterpretation(for: sectionIndex)
            }
        }
        // If not available, interpretations will remain nil and fallback will show
    }
    
    @available(iOS 18.1, *)
    private func generateInterpretation(for sectionIndex: Int) {
        // Set loading state
        loadingStates[sectionIndex] = true
        
        // Collect the 5 combinations for this section
        var combinations: [RoyalReadingInterpreter.CardCombination] = []
        
        for pairIndex in 0..<5 {
            let firstIndex = sectionIndex * 6 + pairIndex
            let secondIndex = sectionIndex * 6 + pairIndex + 1
            
            if let card1 = getCard(at: firstIndex),
               let card2 = getCard(at: secondIndex) {
                let description = getCombinationDescription(card1Name: card1.name, card2Name: card2.name)
                combinations.append(
                    RoyalReadingInterpreter.CardCombination(
                        card1Name: card1.name,
                        card2Name: card2.name,
                        description: description
                    )
                )
            }
        }
        
        // Only generate interpretation if there are valid combinations
        guard !combinations.isEmpty else {
            loadingStates[sectionIndex] = false
            return
        }
        
        // Generate interpretation asynchronously
        Task {
            do {
                let interpreter = RoyalReadingInterpreter()
                let interpretation = try await interpreter.generateInterpretation(
                    for: combinations,
                    in: sectionTitles[sectionIndex]
                )
                
                await MainActor.run {
                    aiInterpretations[sectionIndex] = interpretation
                    loadingStates[sectionIndex] = false
                }
            } catch {
                print("Erro ao gerar interpretação para seção \(sectionIndex): \(error)")
                await MainActor.run {
                    loadingStates[sectionIndex] = false
                    // Interpretation remains nil, will show fallback
                }
            }
        }
    }
    
    private func getCard(at globalIndex: Int) -> Card? {
        guard let numberString = selectedCardNumbers[globalIndex],
              let number = Int(numberString) else {
            return nil
        }
        return allCards.first { Int($0.number) == number }
    }
    
    private func getCombinationDescription(card1Name: String, card2Name: String) -> String {
        let combinationKey = "\(card1Name), \(card2Name)".lowercased()
        if let combination = combinedCards.first(where: { $0.number.lowercased() == combinationKey }) {
            return combination.description
        } else {
            return "Nenhuma combinação encontrada para \(card1Name) e \(card2Name)."
        }
    }
    
    private func saveReading() {
        // Convert aiInterpretations from [Int: String] to [String: String]
        var interpretationsDict: [String: String] = [:]
        for (sectionIndex, interpretation) in aiInterpretations {
            if sectionIndex < sectionTitles.count {
                interpretationsDict[sectionTitles[sectionIndex]] = interpretation
            }
        }
        
        // Create and save the RoyalReading
        let royalReading = RoyalReading(
            cardNumbers: selectedCardNumbers,
            aiInterpretations: interpretationsDict
        )
        
        modelContext.insert(royalReading)
        
        do {
            try modelContext.save()
            saveAlertMessage = "Leitura salva com sucesso em \(royalReading.shortDate)"
            showingSaveAlert = true
        } catch {
            saveAlertMessage = "Erro ao salvar: \(error.localizedDescription)"
            showingSaveAlert = true
        }
    }
    
    private func hasSectionCards(sectionIndex: Int) -> Bool {
        // Check if at least one card is filled in this section
        // Each section has 6 cards (indices: sectionIndex * 6 to sectionIndex * 6 + 5)
        for cardIndex in 0..<6 {
            let globalIndex = sectionIndex * 6 + cardIndex
            if let cardNumber = selectedCardNumbers[globalIndex], !cardNumber.isEmpty {
                return true
            }
        }
        return false
    }
}

#Preview {
    AllCardsReadingView(selectedCardNumbers: [:], allCards: [], sectionTitles: [])
}
