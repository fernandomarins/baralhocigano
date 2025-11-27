//
//  RoyalReading.swift
//  Ciganus
//
//  Created by Fernando Marins on 26/11/25.
//

import Foundation
import SwiftData

@Model
class RoyalReading {
    var id: UUID
    var date: Date
    var cardNumbers: [Int: String] // globalIndex -> cardNumber
    var aiInterpretations: [String: String] // sectionTitle -> interpretation
    
    init(date: Date = Date(), cardNumbers: [Int: String], aiInterpretations: [String: String]) {
        self.id = UUID()
        self.date = date
        self.cardNumbers = cardNumbers
        self.aiInterpretations = aiInterpretations
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
