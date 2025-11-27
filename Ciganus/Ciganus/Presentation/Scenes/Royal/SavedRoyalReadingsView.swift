//
//  SavedRoyalReadingsView.swift
//  Ciganus
//
//  Created by Fernando Marins on 26/11/25.
//

import SwiftUI
import SwiftData

struct SavedRoyalReadingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \RoyalReading.date, order: .reverse) private var savedReadings: [RoyalReading]
    
    var body: some View {
        NavigationView {
            ZStack {
                CosmicBackground()
                
                if savedReadings.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "star.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text("Nenhuma leitura salva")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text("Suas leituras da Mesa Real salvas aparecerão aqui")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(savedReadings) { reading in
                                NavigationLink {
                                    SavedRoyalReadingDetailView(reading: reading)
                                } label: {
                                    SavedReadingRow(reading: reading)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Leituras Salvas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fechar") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

struct SavedReadingRow: View {
    let reading: RoyalReading
    @Environment(\.modelContext) private var modelContext
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(reading.formattedDate)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("\(reading.aiInterpretations.count) \(reading.aiInterpretations.count == 1 ? "seção interpretada" : "seções interpretadas")")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.5))
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
        .contextMenu {
            Button(role: .destructive) {
                showingDeleteAlert = true
            } label: {
                Label("Excluir", systemImage: "trash")
            }
        }
        .alert("Excluir Leitura", isPresented: $showingDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Excluir", role: .destructive) {
                deleteReading()
            }
        } message: {
            Text("Tem certeza que deseja excluir esta leitura?")
        }
    }
    
    private func deleteReading() {
        modelContext.delete(reading)
        try? modelContext.save()
    }
}

struct SavedRoyalReadingDetailView: View {
    let reading: RoyalReading
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            CosmicBackground()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Leitura de \(reading.formattedDate)")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom)
                    
                    ForEach(Array(reading.aiInterpretations.keys.sorted()), id: \.self) { sectionTitle in
                        if let interpretation = reading.aiInterpretations[sectionTitle] {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(sectionTitle)
                                    .font(.headline)
                                    .foregroundColor(.cyan)
                                
                                Text(interpretation)
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.9))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
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
                }
                .padding()
            }
        }
        .navigationTitle("Detalhes da Leitura")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SavedRoyalReadingsView()
        .modelContainer(for: RoyalReading.self)
}
