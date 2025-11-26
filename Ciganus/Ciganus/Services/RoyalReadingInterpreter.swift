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
        // Collect only non-empty description texts from the combinations
        let descriptions = combinations
            .map { $0.description }
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .joined(separator: "\n\n")
        
        let prompt = """
        Contexto: \(sectionTitle)
        
        Textos das combinações de cartas:
        
        \(descriptions)
        
        Com base nesses textos, crie uma interpretação única e coesa que sintetize o significado geral no contexto de "\(sectionTitle)".
        
        A interpretação deve:
        1. Sintetizar os significados apresentados
        2. Ser fluida e coesa, mencionando o nome das cartas combinadas
        3. Ter entre 3-5 parágrafos
        4. Considerar o contexto específico da seção
        
        Interpretação:
        """
        
        return prompt
    }
}

