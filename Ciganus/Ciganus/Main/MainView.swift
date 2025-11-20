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

    private let mysticPastelColors = AppColors.mysticPastels

    var body: some View {
        ZStack {
            AppBackground()

                Group {
                    if viewModel.isLoading {
                        VStack {
                            Spacer()
                            ProgressView("Carregando cartas...")
                                .progressViewStyle(CircularProgressViewStyle())
                            Spacer()
                        }
                    } else if let error = viewModel.errorMessage {
                        VStack(spacing: 16) {
                            Text(error)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                            Button("Tentar novamente") {
                                Task {
                                    await viewModel.carregarCartas()
                                }
                            }
                        }
                        .padding()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.cards.indices, id: \.self) { index in
                                    let card = viewModel.cards[index]

                                    Button(action: {
                                        coordinator.push(.cardDetails(card, false))
                                    }) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("#\(index + 1)")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                            Text(card.name)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                                .lineLimit(2)
                                                .minimumScaleFactor(0.8)
                                        }
                                        .frame(maxWidth: 160, minHeight: 60, alignment: .leading)
                                        .padding()
                                        .background(mysticPastelColors[index % mysticPastelColors.count])
                                        .cornerRadius(12)
                                        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                                    }
                                }
                            }
                            .padding()
                        }
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
                                .foregroundColor(.purple)
                                .frame(width: 60, height: 60)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.leading, 20)
                        Spacer()
                        Button(action: {
                            coordinator.push(.dailyReading)
                        }) {
                            Image(systemName: "plus.message")
                                .font(.largeTitle)
                                .foregroundColor(.purple)
                                .frame(width: 60, height: 60)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        Spacer()
                        Button(action: {
                            coordinator.push(.allCards(viewModel.cards))
                        }) {
                            Image(systemName: "menucard.fill")
                                .font(.largeTitle)
                                .foregroundColor(.purple)
                                .frame(width: 60, height: 60)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
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
