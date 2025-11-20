//
//  AppError.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import Foundation

enum AppError: LocalizedError {
    case invalidCredentials
    case networkError(Error)
    case decodingError(Error)
    case unknown(Error)
    case custom(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Credenciais inválidas. Verifique seu email e senha."
        case .networkError(let error):
            return "Erro de conexão: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Erro ao processar dados: \(error.localizedDescription)"
        case .unknown(let error):
            return "Ocorreu um erro desconhecido: \(error.localizedDescription)"
        case .custom(let message):
            return message
        }
    }
}
