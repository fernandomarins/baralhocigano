//
//  DependencyContainer.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import Foundation

class DependencyContainer {
    static let shared = DependencyContainer()
    
    // Data Sources
    lazy var firebaseDataSource: FirebaseDataSourceProtocol = FirebaseDataSource()
    
    // Repositories
    lazy var cardRepository: CardRepositoryProtocol = CardRepository(firebaseDataSource: firebaseDataSource)
    lazy var authRepository: AuthRepositoryProtocol = AuthRepository(dataSource: firebaseDataSource)
    
    // Use Cases
    lazy var fetchCardsUseCase: FetchCardsUseCaseProtocol = FetchCardsUseCase(repository: cardRepository)
    lazy var loginUseCase: LoginUseCaseProtocol = LoginUseCase(repository: authRepository)
    lazy var registerUseCase: RegisterUseCaseProtocol = RegisterUseCase(repository: authRepository)
    
    private init() {}
}
