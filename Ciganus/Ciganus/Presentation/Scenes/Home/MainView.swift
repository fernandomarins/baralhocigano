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

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private let mysticPastelColors = AppColors.mysticPastels // Mantendo nome da var, mas usando novas cores

    var body: some View {
        ZStack {
            AppBackground()

                Group {
                    switch viewModel.state {
                    case .loading:
                        VStack {
                            Spacer()
                            ProgressView("Carregando cartas...")
                                .progressViewStyle(CircularProgressViewStyle())
                            Spacer()
                        }
                    case .error(let message):
                        VStack(spacing: 16) {
                            Text(message)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                            Button("Tentar novamente") {
                                viewModel.loadData()
                            }
                        }
                        .padding()
                    case .success(let cards):
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(cards.indices, id: \.self) { index in
                                    let card = cards[index]

                                    Button(action: {
                                        coordinator.push(.cardDetails(card, false))
                                    }) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("#\(index + 1)")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(AppColors.antiqueGold)
                                            Text(card.name)
                                                .font(AppFonts.cardTitle)
                                                .foregroundColor(AppColors.textPrimary)
                                                .lineLimit(2)
                                                .minimumScaleFactor(0.8)
                                        }
                                        .frame(maxWidth: 160, minHeight: 60, alignment: .leading)
                                        .padding()
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.antiqueGold, lineWidth: 1)
                                        )
                                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                    }
                                }
                            }
                            .padding()
                        }
                    case .idle:
                        EmptyView()
                    }
                }
                .navigationTitle("Cartas")

                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            coordinator.push(.combinedCards)
                        }) {
                            Image(systemName: "2.circle")
                                .font(.largeTitle)
                                .foregroundColor(AppColors.antiqueGold)
                                .frame(width: 60, height: 60)
                                .background(AppColors.deepSepia)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(AppColors.antiqueGold, lineWidth: 2)
                                )
                                .shadow(color: Color.black.opacity(0.2), radius: 4)
                        }
                        .padding(.leading, 20)
                        Spacer()
                        Button(action: {
                            coordinator.push(.dailyReading)
                        }) {
                            Image(systemName: "plus.message")
                                .font(.largeTitle)
                                .foregroundColor(AppColors.antiqueGold)
                                .frame(width: 60, height: 60)
                                .background(AppColors.deepSepia)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(AppColors.antiqueGold, lineWidth: 2)
                                )
                                .shadow(color: Color.black.opacity(0.2), radius: 4)
                        }
                        Spacer()
                        Button(action: {
                            if let cards = viewModel.state.value {
                                coordinator.push(.allCards(cards))
                            }
                        }) {
                            Image(systemName: "menucard.fill")
                                .font(.largeTitle)
                                .foregroundColor(AppColors.antiqueGold)
                                .frame(width: 60, height: 60)
                                .background(AppColors.deepSepia)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(AppColors.antiqueGold, lineWidth: 2)
                                )
                                .shadow(color: Color.black.opacity(0.2), radius: 4)
                        }
                        .padding(.trailing, 20)
                    }
                    .padding(.bottom, 20)
                    }
        }
        .onAppear {
            viewModel.setContext(modelContext)
            viewModel.loadData()
        }
    }
}

#Preview {
    MainView()
}
