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

    var isValidInput: Bool {
        guard let num1 = Int(cardNumber1), let num2 = Int(cardNumber2) else { return false }
        return (1...36).contains(num1) && (1...36).contains(num2) && num1 != num2
    }

    var body: some View {
        ZStack {
            AppBackground()
                .onTapGesture {
                    focusedField = nil
                }

            VStack(spacing: 20) {
                Text("🔮 Combine as Cartas")
                    .font(AppFonts.title)
                    .foregroundColor(AppColors.textPrimary)
                    .padding(.top)

                HStack(spacing: 16) {
                    VStack {
                        TextField("Número 1", text: $cardNumber1)
                            .padding()
                            .background(AppColors.fieldBackground)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(AppColors.antiqueGold, lineWidth: 1)
                            )
                            .foregroundColor(AppColors.textPrimary)
                            .focused($focusedField, equals: .number1)
                            .keyboardType(.numberPad)
                        if !nameFirstCard.isEmpty {
                            Text("\(nameFirstCard.uppercased())")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.textSecondary)
                                .bold()
                        }
                    }
                    VStack {
                        TextField("Número 2", text: $cardNumber2)
                            .padding()
                            .background(AppColors.fieldBackground)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(AppColors.antiqueGold, lineWidth: 1)
                            )
                            .foregroundColor(AppColors.textPrimary)
                            .focused($focusedField, equals: .number2)
                            .keyboardType(.numberPad)
                        if !nameSecondCard.isEmpty {
                            Text("\(nameSecondCard.uppercased())")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.textSecondary)
                                .bold()
                        }
                    }
                }
                .padding(.horizontal)

                Button(action: buscarCombinacaoPorNomes) {
                    Text("Buscar Combinação")
                        .font(AppFonts.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValidInput ? AppColors.deepSepia : Color.gray.opacity(0.5))
                        .foregroundColor(isValidInput ? AppColors.antiqueGold : Color.white.opacity(0.5))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isValidInput ? AppColors.antiqueGold : Color.clear, lineWidth: 1)
                        )
                }
                .disabled(!isValidInput)
                .padding(.horizontal)

                Text("Resultado da Combinação:")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    .padding(.top)

                ScrollView {
                    Group {
                        if !cardNumber1.isEmpty && !cardNumber2.isEmpty {
                            if let n1 = Int(cardNumber1), let n2 = Int(cardNumber2), n1 == n2 {
                                Text("As cartas não podem ser iguais.")
                                    .font(AppFonts.body)
                                    .foregroundColor(.red.opacity(0.8))
                            } else if !isValidInput {
                                Text("Por favor, insira números válidos entre 1 e 36.")
                                    .font(AppFonts.body)
                                    .foregroundColor(.red.opacity(0.8))
                            } else {
                                Text(combinedDescription.isEmpty ? "Aguardando combinação..." : combinedDescription)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.textPrimary)
                            }
                        } else {
                            Text(combinedDescription.isEmpty ? "Aguardando combinação..." : combinedDescription)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textPrimary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 200)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.antiqueGold, lineWidth: 1)
                )
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
        guard let num1 = Int(cardNumber1), let num2 = Int(cardNumber2) else { return }

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
