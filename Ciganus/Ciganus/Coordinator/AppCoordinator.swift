//
//  AppCoordinator.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI

enum Route: Hashable {
    case login
    case register
    case main
    case combinedCards
    case dailyReading
    case allCards([Card])
    case cardDetails(Card, Bool)
}

@MainActor
class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
