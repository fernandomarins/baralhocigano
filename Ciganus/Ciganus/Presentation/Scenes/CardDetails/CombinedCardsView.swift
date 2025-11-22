//
//  CombinedCardsView.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import SwiftUI

struct CombinedCardsView: View {
    @State private var cardNumber1: String = ""
    @State private var cardNumber2: String = ""
    @State private var combinedDescription: String = ""
    @State private var nameFirstCard: String = ""
    @State private var nameSecondCard: String = ""
    @State private var combinedCards: [CombinedCardModel] = []

    @FocusState private var focusedField: Field?

    enum Field {
        case number1, number2
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.indigo.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .onTapGesture {
                focusedField = nil
            }

            VStack(spacing: 20) {
                Text("🔮 Combine as Cartas")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top)

                HStack(spacing: 16) {
                    VStack {
                        TextField("Número 1", text: $cardNumber1)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .focused($focusedField, equals: .number1)
                        if !nameFirstCard.isEmpty {
                            Text("\(nameFirstCard.uppercased())")
                                .font(.caption)
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                    VStack {
                        TextField("Número 2", text: $cardNumber2)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .focused($focusedField, equals: .number2)
                        if !nameSecondCard.isEmpty {
                            Text("\(nameSecondCard.uppercased())")
                                .font(.caption)
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                }
                .padding(.horizontal)

                Button(action: buscarCombinacaoPorNomes) {
                    Text("Buscar Combinação")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                Text("Resultado da Combinação:")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    .padding(.top)

                ScrollView {
                    Text(combinedDescription.isEmpty ? "Aguardando combinação..." : combinedDescription)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 200)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 40)
        }
        .onAppear {
            getCards()
        }
    }

    func getCards() {
        do {
            combinedCards = try CombinedCards().getCombinedCards()
        } catch {
            print("Erro ao carregar as cartas combinadas: \(error)")
        }
    }

    func buscarCombinacaoPorNomes() {
        guard let num1 = Int(cardNumber1), let num2 = Int(cardNumber2) else {
            combinedDescription = "Por favor, insira números válidos."
            nameFirstCard = ""
            nameSecondCard = ""
            return
        }

        let nomeCarta1 = Source.shared.nomesDasCartas["\(num1)"] ?? ""
        let nomeCarta2 = Source.shared.nomesDasCartas["\(num2)"] ?? ""

        nameFirstCard = nomeCarta1
        nameSecondCard = nomeCarta2

        let combinedName = "\(nomeCarta1), \(nomeCarta2)"

        if let foundCard = combinedCards.first(where: { $0.number.lowercased() == combinedName.lowercased() }) {
            combinedDescription = foundCard.description
        } else {
            combinedDescription = "Nenhuma combinação encontrada para \(combinedName)"
        }

        focusedField = nil
    }
}
