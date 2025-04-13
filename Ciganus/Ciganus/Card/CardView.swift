//
//  CardView.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI
import Foundation

struct CardView: View {
    let card: Card
    let fromAllCard: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.indigo]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if fromAllCard {
                        Text(card.name)
                            .font(.title)
                            .bold()
                            .padding(.top)
                            .foregroundColor(.white)
                    }
                    SectionView(title: "Palavras-chave", content: card.keywords)
                    SectionView(title: "Significados gerais", content: card.generalMeanings)
                    SectionView(title: "Influência Astrológica", content: card.astrologicalInfluence)
                    SectionView(title: "Figura Arquétipica", content: card.archetypeFigure)
                    SectionView(title: "Plano Espiritual", content: card.spiritualPlane)
                    SectionView(title: "Plano Mental", content: card.mentalPlane)
                    SectionView(title: "Plano Emocional", content: card.emotionalPlane)
                    SectionView(title: "Plano Material", content: card.materialPlane)
                    SectionView(title: "Plano Físico (doenças)", content: card.physicalPlane)
                    SectionView(title: "Pontos Positivos", content: card.positivePoints)
                    SectionView(title: "Pontos Negativos", content: card.negativePoints)
                    SectionView(title: "Previsões para o Ano", content: card.yearPrediction)
                    SectionView(title: "Tempo", content: card.time)
                }
                .padding()
            }
            .navigationTitle(card.name)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SectionView: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.title2)
                .bold()
                .foregroundColor(.white) // Garante que o título seja visível
            Text(content)
                .font(.body)
                .foregroundColor(.white.opacity(0.8)) // Texto um pouco transparente para melhor leitura
        }
    }
}

#Preview {
    CardView(card: .init(number: "1", name: "Cavaleiro", keywords: "O guia espiritual que o conduz. Ele conhece os caminhos e passagens a seguir. Ele pode te guiar.Ele sabe os caminhos que você pode transitar. Conexão", generalMeanings: "Alerta do que está por vir positiva e negativamente. Notícias. Movimento. Algo próximo a se concretizar que pode ter conexão kármica. O guia espiritual que conduz o atendido e que o tarólogo vai juntamente com os seus guias conectá-lo para que o mesmo auxilie nas mensagens. O guia espiritual mostra tudo o que está chegando à vida do atendido bem como os bloqueios kármicos que estão impedindo a realização dos seus desejos mais intrínsecos. Quando esta carta vir antes de qualquer carta indica o que ainda não se concretizou e está por vir. Quando esta carta vem após outra, indica algo já materializado", astrologicalInfluence: "Lua em Touro", archetypeFigure: "O Mago do poder", spiritualPlane: "Ativo espiritualmente. Sugere proteção de crianças e do Arcanjo Miguel", mentalPlane: "Habilidade. Idéias claras, ação (sabe o que quer).", emotionalPlane: "Conquista. Um novo amor. Tende a ser bastante ciumenta (o). Costuma ter uma vida sexual muito ativa. Momentos afetivos, felizes.", materialPlane: "Dinheiro através do trabalho; é uma carta de ação. Movimento, circunstâncias materiais favorecerão o atendido. Geralmente está ligado a profissões como inventor, engenheiro, professor, diretor de empresa, advogado. Em alguns casos são autônomos, sendo donos da própria empresa.", physicalPlane: "Problemas de circulação e cabeça. Pressão alta, problemas de vista. Cuidado com acidentes. Problemas com os pés ou pernas.", positivePoints: "Sensibilidade. Talento artístico. Potenciais psíquicos", negativePoints:  "Charlatão. Aproveitador. Superficial. Impulsividade. Indecisão", yearPrediction: "Neste ano você estará tendo a oportunidade de começar tudo de novo. Isto vale para o ano todo: novas ideias, novas pessoas, um novo amor, mudanças significativas estarão presentes. É hora de agir, de mostrar sua total capacidade. Seja independente.", time: "Agora"), fromAllCard: false)
}
