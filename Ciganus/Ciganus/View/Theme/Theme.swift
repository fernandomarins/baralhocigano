//
//  Theme.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI

struct AppColors {
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.purple, Color.indigo]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let mysticPastels: [Color] = [
        Color(red: 0.80, green: 0.60, blue: 0.80), // Roxo pastel
        Color(red: 0.68, green: 0.85, blue: 0.90), // Azul pastel suave
        Color(red: 0.86, green: 0.82, blue: 0.95), // Lilás pastel
        Color(red: 0.78, green: 0.71, blue: 0.92), // Lavanda suave
        Color(red: 0.64, green: 0.64, blue: 0.86)  // Azul arroxeado pastel
    ]
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let fieldBackground = Color.white.opacity(0.12)
}

struct AppFonts {
    static let title = Font.largeTitle.bold()
    static let headline = Font.headline
    static let body = Font.body
    static let caption = Font.caption
}
