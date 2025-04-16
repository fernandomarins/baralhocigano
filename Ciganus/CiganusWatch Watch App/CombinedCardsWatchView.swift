//
//  CombinedCardsWatchView.swift
//  CiganusWatch Watch App
//
//  Created by Fernando Marins on 14/04/25.
//

import SwiftUI
#if os(watchOS)
import WatchKit // Importe WatchKit para acessar WKKeyboardType

struct CombinedCardsWatchView: View {
    @State private var cardNumber1: String = ""
    @State private var cardNumber2: String = ""
    @State private var combinedDescription: String = ""
    @State private var nameFirstCard: String = ""
    @State private var nameSecondCard: String = ""
    @State private var combinedCards: [CombinedCardModel] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("🔮 Combine Cartas")
                    .font(.title3)
                    .bold()
                    .foregroundColor(Color.white) // Especificar Color
                    .padding(.bottom, 5)

                TextField("Carta 1", text: $cardNumber1)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
                    .foregroundColor(Color.white)
                    .onChange(of: cardNumber1) { old, new in
                        let filtered = new.filter { "0123456789".contains($0) }
                        if filtered != new {
                            cardNumber1 = filtered
                        }
                        nameFirstCard = Source.shared.nomesDasCartas[cardNumber1] ?? ""
                        updateCombinedDescription()
                    }
                if !nameFirstCard.isEmpty {
                    Text(nameFirstCard.uppercased())
                        .font(.caption2)
                        .foregroundColor(Color.white)
                        .bold()
                }

                TextField("Carta 2", text: $cardNumber2)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
                    .foregroundColor(Color.white)
                    .onChange(of: cardNumber2) { old, new in
                        let filtered = new.filter { "0123456789".contains($0) }
                        if filtered != new {
                            cardNumber2 = filtered
                        }
                        nameSecondCard = Source.shared.nomesDasCartas[cardNumber2] ?? ""
                        updateCombinedDescription()
                    }
                if !nameSecondCard.isEmpty {
                    Text(nameSecondCard.uppercased())
                        .font(.caption2)
                        .foregroundColor(Color.white)
                        .bold()
                }

                Divider()
                    .background(Color.white.opacity(0.5))
                    .padding(.vertical, 8)

                Text("Resultado:")
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 2)

                Text(combinedDescription.isEmpty ? "Aguardando combinação..." : combinedDescription)
                    .font(.body)
                    .foregroundColor(Color.white)
            }
            .padding()
            .onAppear(perform: getCards)
        }
        .background(Color.indigo.opacity(0.8))
        .navigationTitle("Combinação")
    }

    func getCards() {
        do {
            combinedCards = try CombinedCards().getCombinedCards()
        } catch {
            print("Erro ao carregar as cartas combinadas: \(error)")
        }
    }

    func updateCombinedDescription() {
        guard let num1 = cardNumber1.isEmpty ? nil : Int(cardNumber1),
              let num2 = cardNumber2.isEmpty ? nil : Int(cardNumber2) else {
            combinedDescription = "Insira os números das duas cartas."
            return
        }

        let nomeCarta1 = Source.shared.nomesDasCartas["\(num1)"] ?? ""
        let nomeCarta2 = Source.shared.nomesDasCartas["\(num2)"] ?? ""

        if !nomeCarta1.isEmpty && !nomeCarta2.isEmpty {
            let combinedName = "\(nomeCarta1), \(nomeCarta2)"
            if let foundCard = combinedCards.first(where: { $0.number.lowercased() == combinedName.lowercased() }) {
                combinedDescription = foundCard.description
            } else {
                combinedDescription = "Nenhuma combinação encontrada para \(nomeCarta1) e \(nomeCarta2)."
            }
        } else if !cardNumber1.isEmpty || !cardNumber2.isEmpty {
            combinedDescription = (cardNumber1.isEmpty ? "Insira o número da primeira carta." : "") +
                                  (cardNumber2.isEmpty ? " Insira o número da segunda carta." : "")
                                  .trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            combinedDescription = "Insira os números das duas cartas."
        }

        nameFirstCard = nomeCarta1
        nameSecondCard = nomeCarta2
    }
}

struct CombinedCardsWatchView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedCardsWatchView()
    }
}
#endif
