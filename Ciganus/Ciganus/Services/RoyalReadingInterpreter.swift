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
        Você é um tarólogo especialista em Baralho Cigano.
        Responda em português do Brasil, com linguagem acessível,
        sem listar as cartas individualmente, fazendo uma síntese coesa.
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
        let card1Name: String
        let card2Name: String
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
        var prompt = """
        Você é um especialista em Tarot Cigano. Analise as seguintes 5 combinações de cartas no contexto de "\(sectionTitle)" e crie uma interpretação única e coesa que sintetize o significado geral dessas cartas neste contexto específico.
        
        Combinações:
        
        """
        
        for (index, combo) in combinations.enumerated() {
            prompt += """
            \(index + 1). \(combo.card1Name) + \(combo.card2Name):
            \(combo.description)
            
            """
        }
        
        prompt += """
        
        Crie uma interpretação em português que:
        1. Sintetize o significado dessas 5 combinações
        2. Considere o contexto específico de "\(sectionTitle)"
        3. Seja coesa e fluida (não liste as combinações individualmente)
        4. Tenha entre 3-5 parágrafos
        5. Use uma linguagem acessível mas profissional
        
        Interpretação:
        """
        
        return prompt
    }
}

