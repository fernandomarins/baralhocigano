//
//  MainView.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private let mysticPastelColors: [Color] = [
        Color(red: 0.80, green: 0.60, blue: 0.80), // Roxo pastel
        Color(red: 0.68, green: 0.85, blue: 0.90), // Azul pastel suave
        Color(red: 0.86, green: 0.82, blue: 0.95), // Lilás pastel
        Color(red: 0.78, green: 0.71, blue: 0.92), // Lavanda suave
        Color(red: 0.64, green: 0.64, blue: 0.86)  // Azul arroxeado pastel
    ]

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.indigo]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

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
                                viewModel.carregarCartas()
                            }
                        }
                        .padding()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.cards.indices, id: \.self) { index in
                                    let card = viewModel.cards[index]

                                    NavigationLink(destination: CardView(card: card, fromAllCard: false)) {
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
                        NavigationLink(destination: CombinedCardsView()) {
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
                        NavigationLink(destination: DailyReadingView()) {
                            Image(systemName: "plus.message")
                                .font(.largeTitle)
                                .foregroundColor(.purple)
                                .frame(width: 60, height: 60)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        Spacer()
                        NavigationLink(destination: AllCardsView(allCards: viewModel.cards)) {
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
        }
        .onAppear {
            viewModel.carregarCartas()
        }
    }
}

#Preview {
    MainView()
}
