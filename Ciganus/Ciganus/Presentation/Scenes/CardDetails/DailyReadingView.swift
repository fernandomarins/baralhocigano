//
//  DailyReadingView.swift
//  Ciganus
//
//  Created by Fernando Marins on 12/04/25.
//

import SwiftUI
import SwiftData

struct DailyReadingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Reading.date, order: .reverse) private var readings: [Reading]
    @Query private var allCards: [Card]
    
    @State private var showingAddCardView = false
    @State private var selectedReading: Reading?
    @State private var selectedReadingType: ReadingType?
    @State private var selectedReadingCards: [CardInfo] = []
    @State private var showingInterpretationView = false
    @State private var combinedCards: [CombinedCardModel] = []

    var body: some View {
        ZStack {
            CosmicBackground()

            VStack {
                if readings.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "sparkles.rectangle.stack")
                            .font(.system(size: 60))
                            .foregroundColor(.cyan.opacity(0.8))
                        Text("Nenhuma leitura ainda")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Toque no + para adicionar sua primeira leitura")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(readings) { reading in
                            ReadingRowView(reading: reading, combinedCards: combinedCards, allCards: allCards)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    selectedReading = reading
                                    selectedReadingType = reading.type
                                }
                        }
                        .onDelete(perform: deleteReading)
                    }
                    .listStyle(.plain)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .sheet(item: $selectedReading) { reading in
                        DailyInterpretationView(pairs: reading.pairs, readingType: reading.type)
                    }
                }

                Spacer()

                Button {
                    showingAddCardView = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title.weight(.bold))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.cyan, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .shadow(color: .cyan.opacity(0.5), radius: 10, x: 0, y: 0)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.bottom)
            }
            .padding()
            .navigationTitle("Leituras")
            .sheet(isPresented: $showingAddCardView) {
                AddReadingView(onReadingAdded: { newReading in
                    modelContext.insert(newReading)
                })
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            loadCombinedCards()
        }
    }

    func deleteReading(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(readings[index])
        }
    }
    
    func loadCombinedCards() {
        do {
            combinedCards = try CombinedCards().getCombinedCards()
        } catch {
            print("Erro ao carregar cartas combinadas: \(error)")
        }
    }
}

struct DailyReadingView_Previews: PreviewProvider {
    static var previews: some View {
        DailyReadingView()
            .preferredColorScheme(.dark)
            .modelContainer(for: Reading.self, inMemory: true)
    }
}
