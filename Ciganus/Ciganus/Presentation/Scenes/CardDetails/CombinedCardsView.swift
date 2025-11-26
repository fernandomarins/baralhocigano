//
//  CombinedCardsView.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import SwiftUI

struct CombinedCardsView: View {
    @StateObject private var viewModel = CombinedCardsViewModel()
    @FocusState private var focusedField: Field?

    enum Field {
        case number1, number2
    }

    var body: some View {
        ZStack {
            CosmicBackground()
                .onTapGesture {
                    focusedField = nil
                }

            VStack(spacing: 20) {
                Text("🔮 Combine as Cartas")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple.opacity(0.9), .blue.opacity(0.9), .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .purple.opacity(0.5), radius: 10)
                    .padding(.top)

                HStack(spacing: 16) {
                    VStack {
                        TextField("Número 1", text: $viewModel.cardNumber1)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.black.opacity(0.3))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.purple.opacity(0.6), .blue.opacity(0.4), .cyan.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                            .foregroundColor(.white)
                            .focused($focusedField, equals: .number1)
                            .keyboardType(.numberPad)
                        if !viewModel.nameFirstCard.isEmpty {
                            Text("\(viewModel.nameFirstCard.uppercased())")
                                .font(.caption)
                                .foregroundColor(.cyan)
                                .bold()
                        }
                    }
                    VStack {
                        TextField("Número 2", text: $viewModel.cardNumber2)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.black.opacity(0.3))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.purple.opacity(0.6), .blue.opacity(0.4), .cyan.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                            .foregroundColor(.white)
                            .focused($focusedField, equals: .number2)
                            .keyboardType(.numberPad)
                        if !viewModel.nameSecondCard.isEmpty {
                            Text("\(viewModel.nameSecondCard.uppercased())")
                                .font(.caption)
                                .foregroundColor(.cyan)
                                .bold()
                        }
                    }
                }
                .padding(.horizontal)

                PrimaryButton(
                    title: "Buscar Combinação",
                    isDisabled: !viewModel.isValidInput,
                    action: {
                        viewModel.buscarCombinacaoPorNomes()
                        focusedField = nil
                    }
                )
                .padding(.horizontal)

                Text("Resultado da Combinação:")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    .padding(.top)

                ScrollView {
                    Group {
                        if !viewModel.cardNumber1.isEmpty && !viewModel.cardNumber2.isEmpty {
                            if let n1 = Int(viewModel.cardNumber1), let n2 = Int(viewModel.cardNumber2), n1 == n2 {
                                Text("As cartas não podem ser iguais.")
                                    .font(.body)
                                    .foregroundColor(.red.opacity(0.8))
                            } else if !viewModel.isValidInput {
                                Text("Por favor, insira números válidos entre 1 e 36.")
                                    .font(.body)
                                    .foregroundColor(.red.opacity(0.8))
                            } else {
                                Text(viewModel.combinedDescription.isEmpty ? "Aguardando combinação..." : viewModel.combinedDescription)
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        } else {
                            Text(viewModel.combinedDescription.isEmpty ? "Aguardando combinação..." : viewModel.combinedDescription)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 200)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.3))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [.purple.opacity(0.3), .blue.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 40)
        }
        .onAppear {
            viewModel.loadCards()
        }
    }
}
