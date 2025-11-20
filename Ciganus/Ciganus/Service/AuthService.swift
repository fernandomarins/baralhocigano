//
//  AuthService.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import Foundation
import FirebaseAuth

protocol AuthServicing {
    func login(email: String, password: String) async throws
    func register(email: String, password: String) async throws
    func logout() throws
    func getCurrentUser() -> User?
}

class AuthService: AuthServicing {
    static let shared = AuthService()
    
    private init() {}

    func login(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch let error as NSError {
            let authErrorCode = AuthErrorCode(rawValue: error.code)
            switch authErrorCode {
            case .wrongPassword, .userNotFound, .invalidEmail:
                throw AppError.invalidCredentials
            case .networkError:
                throw AppError.networkError(error)
            default:
                throw AppError.unknown(error)
            }
        } catch {
            throw AppError.unknown(error)
        }
    }

    func register(email: String, password: String) async throws {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } catch let error as NSError {
            let authErrorCode = AuthErrorCode(rawValue: error.code)
            switch authErrorCode {
            case .emailAlreadyInUse:
                throw AppError.custom("Este e-mail já está em uso.")
            case .invalidEmail:
                throw AppError.custom("E-mail inválido.")
            case .weakPassword:
                throw AppError.custom("A senha é muito fraca.")
            default:
                throw AppError.networkError(error)
            }
        } catch {
            throw AppError.unknown(error)
        }
    }
    
    func logout() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw AppError.unknown(error)
        }
    }

    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
}
