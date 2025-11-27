//
//  InterpretationRowView.swift
//  Ciganus
//
//  Created by Fernando Marins on 26/11/25.
//

import SwiftUI

struct InterpretationRowView: View {
    let pair: ReadingPair
    let interpretation: String
    let fullHiddenCard: Card?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\(Int(pair.card1.number) ?? 0) - \(pair.card1.name)")
                    .font(.headline)
                    .foregroundColor(.cyan)
                Text("e")
                    .foregroundColor(.white.opacity(0.5))
                Text("\(Int(pair.card2.number) ?? 0) - \(pair.card2.name)")
                    .font(.headline)
                    .foregroundColor(.cyan)
            }
            .padding(.bottom, 4)
            
            Divider()
                .background(Color.white.opacity(0.2))

            Text(interpretation)
                .foregroundColor(.white.opacity(0.9))
                .font(.body)
                .lineSpacing(4)
            
            if let hidden = pair.hiddenCard, let fullCard = fullHiddenCard {
                Divider()
                    .background(Color.white.opacity(0.1))
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Carta Oculta:")
                            .font(.headline)
                            .foregroundColor(.purple)
                        Text("\(Int(hidden.number) ?? 0) - \(hidden.name)")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 4)
                    
                    Group {
                        SectionView(title: "Palavras-chave", content: fullCard.keywords)
                        SectionView(title: "Significados gerais", content: fullCard.generalMeanings)
                        SectionView(title: "Influência Astrológica", content: fullCard.astrologicalInfluence)
                        SectionView(title: "Figura Arquétipica", content: fullCard.archetypeFigure)
                        SectionView(title: "Plano Espiritual", content: fullCard.spiritualPlane)
                        SectionView(title: "Plano Mental", content: fullCard.mentalPlane)
                        SectionView(title: "Plano Emocional", content: fullCard.emotionalPlane)
                        SectionView(title: "Plano Material", content: fullCard.materialPlane)
                        SectionView(title: "Plano Físico (doenças)", content: fullCard.physicalPlane)
                        SectionView(title: "Pontos Positivos", content: fullCard.positivePoints)
                        SectionView(title: "Pontos Negativos", content: fullCard.negativePoints)
                        
                        if !fullCard.yearPrediction.isEmpty {
                            SectionView(title: "Previsões para o Ano", content: fullCard.yearPrediction)
                        }
                        
                        if !fullCard.time.isEmpty {
                            SectionView(title: "Tempo", content: fullCard.time)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.purple.opacity(0.3), .cyan.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}
