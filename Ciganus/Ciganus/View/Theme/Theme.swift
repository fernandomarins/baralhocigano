//
//  Theme.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI

struct AppColors {
    // Tema Vintage Clássico (Pergaminho/Sepia)
    
    // Fundo tipo Pergaminho
    static let parchmentBackground = Color(red: 0.96, green: 0.96, blue: 0.86) // Bege claro (#F5F5DC)
    static let parchmentDarker = Color(red: 0.91, green: 0.88, blue: 0.84) // Bege um pouco mais escuro para gradiente
    
    // Acentos
    static let antiqueGold = Color(red: 0.72, green: 0.53, blue: 0.04) // Dourado envelhecido/Bronze (#B8860B)
    static let deepSepia = Color(red: 0.24, green: 0.15, blue: 0.14) // Marrom café bem escuro (#3E2723)
    
    static let cardBackground = Color.white.opacity(0.9) // Cartas claras
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [parchmentBackground, parchmentDarker]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Cores para categorias ou destaques sutis (tons terrosos/vintage)
    static let mysticPastels: [Color] = [
        Color(red: 0.80, green: 0.70, blue: 0.60), // Bege terra
        Color(red: 0.70, green: 0.75, blue: 0.70), // Verde sálvia pálido
        Color(red: 0.75, green: 0.70, blue: 0.75), // Lilás poeirento
        Color(red: 0.85, green: 0.80, blue: 0.70), // Areia
        Color(red: 0.70, green: 0.75, blue: 0.80)  // Azul acinzentado
    ]
    
    static let textPrimary = deepSepia // Texto escuro para alto contraste
    static let textSecondary = Color.gray
    static let fieldBackground = Color.black.opacity(0.05)
}

struct AppFonts {
    // System Serif para legibilidade clássica
    static let title = Font.system(size: 32, weight: .bold, design: .serif)
    static let cardTitle = Font.system(size: 18, weight: .bold, design: .serif)
    static let headline = Font.headline
    static let body = Font.body
    static let caption = Font.caption
}
