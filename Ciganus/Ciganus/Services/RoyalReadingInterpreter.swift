//
//  RoyalReadingInterpreter.swift
//  Ciganus
//
//  Created by Fernando Marins on 26/11/25.
//

import Foundation
import SwiftUI

#if canImport(FoundationModels)
import FoundationModels
#endif

protocol TextGenerating {
    func generate(prompt: String) async throws -> String
}

struct SimulatedTextGenerator: TextGenerating {
    func generate(prompt: String) async throws -> String {
        try await Task.sleep(for: .seconds(2))
        return """
        [Interpretação simulada]
        
        Esta é uma interpretação de exemplo que seria gerada pela Apple Intelligence em um dispositivo compatível.
        
        A interpretação real combinará os significados das 5 combinações de cartas de forma coesa e contextualizada para a seção específica.
        """
    }
}

#if canImport(FoundationModels)
@available(iOS 26.0, *)
struct FoundationModelsTextGenerator: TextGenerating {
    func generate(prompt: String) async throws -> String {
        let model = SystemLanguageModel.default

        // 1. Garante que o modelo está disponível
        guard case .available = model.availability else {
            throw RoyalReadingInterpreter.InterpreterError.modelUnavailable
        }

        // 2. Instruções fixas para o modelo (como se fosse o “system prompt”)
        let instructions = """
        Você é um especialista em Baralho Cigano.
        Responda em português do Brasil, com linguagem acessível.
        Não use terminologia de Tarot (como Arcanos).
        Faça uma síntese coesa das combinações apresentadas, sempre usando o viés kármico.
        """

        // 3. Cria a sessão
        let session = LanguageModelSession(instructions: instructions)

        // 4. Opções de geração (ajuste conforme o feeling da leitura)
        let options = GenerationOptions(temperature: 0.8)

        // 5. Pede resposta para o modelo
        let response = try await session.respond(to: prompt, options: options)

        return response.content
    }
}
#endif

actor RoyalReadingInterpreter {
    
    // MARK: - Types
    
    struct CardCombination {
        let card1: Card
        let card2: Card
        let description: String
    }
    
    enum InterpreterError: Error {
        case modelUnavailable
        case generationFailed
        case unsupportedDevice
    }
    
    // MARK: - Dependencies
    private let generator: TextGenerating
    
    init(generator: TextGenerating? = nil) {
    #if canImport(FoundationModels)
        if #available(iOS 26.0, *),
           generator == nil,
           SystemLanguageModel.default.availability == .available {
            // Usa o modelo da Apple se estiver disponível
            self.generator = FoundationModelsTextGenerator()
        } else {
            // Fallback: simulador (ou um gerador próprio seu, remoto, etc.)
            self.generator = generator ?? SimulatedTextGenerator()
        }
    #else
        // Plataformas que não têm FoundationModels
        self.generator = generator ?? SimulatedTextGenerator()
    #endif
    }
    
    // MARK: - Public Methods
    
    func generateInterpretation(
        for combinations: [CardCombination],
        in sectionTitle: String
    ) async throws -> String {
        let prompt = buildPrompt(combinations: combinations, sectionTitle: sectionTitle)
        return try await generator.generate(prompt: prompt)
    }
    
    // MARK: - Private Methods
    
    private func buildPrompt(combinations: [CardCombination], sectionTitle: String) -> String {
        // Build a detailed description for each combination
        let descriptions = combinations.map { combination in
            """
            PAR DE CARTAS:
            Carta 1: \(combination.card1.name)
            - Palavras-chave: \(combination.card1.keywords)
            - Significados: \(combination.card1.generalMeanings)
            
            Carta 2: \(combination.card2.name)
            - Palavras-chave: \(combination.card2.keywords)
            - Significados: \(combination.card2.generalMeanings)
            
            Descrição da Combinação no App:
            \(combination.description)
            """
        }.joined(separator: "\n\n---\n\n")
        
        let prompt = """
        Contexto: \(sectionTitle)
        Sistema: Baralho Cigano (Lenormand)
        
        DADOS OFICIAIS DAS CARTAS (USE APENAS ESTES DADOS):
        
        \(descriptions)
        
        Com base EXCLUSIVAMENTE nos dados fornecidos acima, crie uma interpretação única e coesa que sintetize o significado geral no contexto de "\(sectionTitle)".
        
        A interpretação deve:
        1. Focar exclusivamente no simbolismo do Baralho Cigano (Lenormand) fornecido.
        2. NÃO inventar significados ou nomes de cartas que não estejam listados acima.
        3. Sintetizar os significados apresentados de forma fluida.
        4. Ter entre 3-5 parágrafos.
        5. Considerar o contexto específico da seção.
        
        Interpretação:
        """
        
        return prompt
    }
}

