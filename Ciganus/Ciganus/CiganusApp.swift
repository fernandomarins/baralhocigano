//
//  CiganusApp.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct YourApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                LoginView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .login:
                            LoginView()
                        case .register:
                            RegisterView()
                        case .main:
                            MainView()
                        case .combinedCards:
                            CombinedCardsView()
                        case .dailyReading:
                            DailyReadingView()
                        case .allCards(let cards):
                            AllCardsView(allCards: cards)
                        case .cardDetails(let card, let fromAllCard):
                            CardView(card: card, fromAllCard: fromAllCard)
                        }
                    }
            }
            .environmentObject(coordinator)
        }
        .modelContainer(for: Card.self)
    }
}
