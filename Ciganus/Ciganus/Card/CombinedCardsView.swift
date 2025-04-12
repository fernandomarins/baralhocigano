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
                            .keyboardType(.numberPad)
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
                            .keyboardType(.numberPad)
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
            combinedCards = try CombinedCardsModel().getCombinedCards()
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

        let nomeCarta1 = nomesDasCartas["\(num1)"] ?? ""
        let nomeCarta2 = nomesDasCartas["\(num2)"] ?? ""

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

    private let nomesDasCartas: [String: String] = [
        "1": "Cavaleiro", "2": "Trevo", "3": "Navio", "4": "Casa", "5": "Árvore", "6": "Nuvens", "7": "Cobra", "8": "Caixão",
        "9": "Buquê", "10": "Foice", "11": "Chicote", "12": "Pássaros", "13": "Criança", "14": "Raposa", "15": "Urso", "16": "Estrelas",
        "17": "Cegonha", "18": "Cachorro", "19": "Torre", "20": "Jardim", "21": "Montanha", "22": "Caminhos", "23": "Rato", "24": "Coração",
        "25": "Anel", "26": "Livros", "27": "Carta", "28": "Homem", "29": "Mulher", "30": "Lírios", "31": "Sol", "32": "Lua",
        "33": "Chave", "34": "Peixes", "35": "Âncora", "36": "Cruz"
    ]
}

struct CombinedCardModel: Decodable {
    let number: String
    let description: String
}

class CombinedCardsModel {
    enum JSONReadingError: Error {
        case fileNotFound
        case invalidData
        case jsonDecodingFailed(Error)
    }

    func getCombinedCards() throws -> [CombinedCardModel] {
        return try readJSONFromFile(filename: "cards_data")
    }

    private func readJSONFromFile(filename: String) throws -> [CombinedCardModel] {
        guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw JSONReadingError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode([CombinedCardModel].self, from: data) // Decodifica um array de CombinedCardModel
            return decodedObject
        } catch {
            if let decodingError = error as? JSONReadingError {
                throw decodingError
            } else {
                throw JSONReadingError.jsonDecodingFailed(error)
            }
        }
    }
}
