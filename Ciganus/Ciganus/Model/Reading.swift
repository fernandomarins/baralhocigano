//
//  Reading.swift
//  Ciganus
//
//  Created by Fernando Marins on 26/11/25.
//

import Foundation
import SwiftData

@Model
class Reading {
    var id: UUID
    var type: ReadingType
    var pairs: [ReadingPair]
    var date: Date
    
    init(type: ReadingType, pairs: [ReadingPair], date: Date = Date()) {
        self.id = UUID()
        self.type = type
        self.pairs = pairs
        self.date = date
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ReadingPair: Hashable, Codable, Identifiable {
    var id = UUID()
    var card1: CardInfo
    var card2: CardInfo
    var hiddenCard: CardInfo?
}

struct CardInfo: Hashable, Codable {
    var number: String
    var name: String
}

enum ReadingType: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case client = "Cliente"
    case daily = "Diária"
    case weekly = "Semanal"
    case monthly = "Mensal"
}
