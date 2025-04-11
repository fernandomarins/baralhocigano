//
//  MainView.swift
//  Ciganus
//
//  Created by Fernando Marins on 10/04/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
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
                            ForEach(viewModel.cartas.indices, id: \.self) { index in
                                let carta = viewModel.cartas[index]
                                
                                NavigationLink(destination: CardView(card: carta)) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("#\(index + 1)")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.gray)
                                        Text(carta.name)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.8)
                                    }
                                    .frame(maxWidth: 160, minHeight: 60, alignment: .leading)
                                    .padding()
                                    .background(Color(.systemGray6))
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
        }
        .onAppear {
            viewModel.carregarCartas()
        }
    }
}

#Preview {
    MainView()
}
