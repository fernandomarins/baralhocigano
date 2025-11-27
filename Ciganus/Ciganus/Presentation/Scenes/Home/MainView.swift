//
//  MainView.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @EnvironmentObject var coordinator: AppCoordinator
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            // Cosmic background
            CosmicBackground()
            
            VStack(spacing: 0) {
                // Header with cosmic glow
                VStack(spacing: 8) {
                    Text("🔮 Baralho Cigano")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple.opacity(0.9), .blue.opacity(0.9), .cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .purple.opacity(0.5), radius: 10)
                        .shadow(color: .blue.opacity(0.3), radius: 20)
                }
                .padding(.top, 40)
                .padding(.bottom, 20)
                
                // Cards grid
                if let cards = viewModel.state.value {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(cards.indices, id: \.self) { index in
                                let card = cards[index]
                                CosmicCardView(
                                    cardNumber: index + 1,
                                    cardName: card.name,
                                    index: index
                                )
                                .onTapGesture {
                                    coordinator.push(.cardDetails(card, false))
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .cyan))
                        .scaleEffect(1.5)
                }
                
                Spacer()
            }
            
            // Bottom navigation with cosmic style
            VStack {
                Spacer()
                HStack(spacing: 40) {
                    CosmicButton(icon: "2.circle", action: {
                        coordinator.push(.combinedCards)
                    })
                    
                    CosmicButton(icon: "plus.message", action: {
                        coordinator.push(.dailyReading)
                    })
                    
                    CosmicButton(icon: "menucard.fill", action: {
                        if let cards = viewModel.state.value {
                            coordinator.push(.allCards(cards))
                        }
                    })
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 30)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Capsule()
                                .stroke(
                                    LinearGradient(
                                        colors: [.purple.opacity(0.5), .blue.opacity(0.5)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: .purple.opacity(0.3), radius: 20)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            viewModel.setContext(modelContext)
            viewModel.loadData()
        }
    }
}



// MARK: - Cosmic Card View
struct CosmicCardView: View {
    let cardNumber: Int
    let cardName: String
    let index: Int
    @State private var appeared = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("#\(cardNumber)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text(cardName)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
        .padding()
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.15, green: 0.1, blue: 0.25).opacity(0.8),
                                Color(red: 0.1, green: 0.05, blue: 0.2).opacity(0.9)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [.purple.opacity(0.6), .blue.opacity(0.4), .cyan.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
        )
        .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
        .shadow(color: .blue.opacity(0.2), radius: 15)
        .scaleEffect(appeared ? 1 : 0.8)
        .opacity(appeared ? 1 : 0)
        .animation(
            .spring(response: 0.6, dampingFraction: 0.7)
            .delay(Double(index) * 0.05),
            value: appeared
        )
        .onAppear {
            appeared = true
        }
    }
}

// MARK: - Cosmic Button
struct CosmicButton: View {
    let icon: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.2, green: 0.15, blue: 0.3).opacity(0.8),
                                    Color(red: 0.15, green: 0.1, blue: 0.25).opacity(0.9)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.purple.opacity(0.6), .blue.opacity(0.4), .cyan.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: .purple.opacity(0.4), radius: 10)
                .shadow(color: .cyan.opacity(0.3), radius: 15)
                .scaleEffect(isPressed ? 0.9 : 1.0)
        }
    }
}
