//
//  AppBackground.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            // Textura sutil de papel (opcional, por enquanto apenas cor sólida/gradiente)
            Color.white.opacity(0.1)
                .blendMode(.overlay)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    AppBackground()
}
