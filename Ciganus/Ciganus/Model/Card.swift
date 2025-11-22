//
//  Card.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import SwiftData

@Model
final class Card: Codable, Equatable, Hashable {
    @Attribute(.unique) var number: String
    var name: String
    var keywords: String
    var generalMeanings: String
    var astrologicalInfluence: String
    var archetypeFigure: String
    var spiritualPlane: String
    var mentalPlane: String
    var emotionalPlane: String
    var materialPlane: String
    var physicalPlane: String
    var positivePoints: String
    var negativePoints: String
    var yearPrediction: String
    var time: String
    
    init(number: String, name: String, keywords: String, generalMeanings: String, astrologicalInfluence: String, archetypeFigure: String, spiritualPlane: String, mentalPlane: String, emotionalPlane: String, materialPlane: String, physicalPlane: String, positivePoints: String, negativePoints: String, yearPrediction: String, time: String) {
        self.number = number
        self.name = name
        self.keywords = keywords
        self.generalMeanings = generalMeanings
        self.astrologicalInfluence = astrologicalInfluence
        self.archetypeFigure = archetypeFigure
        self.spiritualPlane = spiritualPlane
        self.mentalPlane = mentalPlane
        self.emotionalPlane = emotionalPlane
        self.materialPlane = materialPlane
        self.physicalPlane = physicalPlane
        self.positivePoints = positivePoints
        self.negativePoints = negativePoints
        self.yearPrediction = yearPrediction
        self.time = time
    }
    
    enum CodingKeys: String, CodingKey {
        case number, name, keywords, generalMeanings, astrologicalInfluence, archetypeFigure, spiritualPlane, mentalPlane, emotionalPlane, materialPlane, physicalPlane, positivePoints, negativePoints, yearPrediction, time
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        number = try container.decode(String.self, forKey: .number)
        name = try container.decode(String.self, forKey: .name)
        keywords = try container.decode(String.self, forKey: .keywords)
        generalMeanings = try container.decode(String.self, forKey: .generalMeanings)
        astrologicalInfluence = try container.decode(String.self, forKey: .astrologicalInfluence)
        archetypeFigure = try container.decode(String.self, forKey: .archetypeFigure)
        spiritualPlane = try container.decode(String.self, forKey: .spiritualPlane)
        mentalPlane = try container.decode(String.self, forKey: .mentalPlane)
        emotionalPlane = try container.decode(String.self, forKey: .emotionalPlane)
        materialPlane = try container.decode(String.self, forKey: .materialPlane)
        physicalPlane = try container.decode(String.self, forKey: .physicalPlane)
        positivePoints = try container.decode(String.self, forKey: .positivePoints)
        negativePoints = try container.decode(String.self, forKey: .negativePoints)
        yearPrediction = try container.decode(String.self, forKey: .yearPrediction)
        time = try container.decode(String.self, forKey: .time)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number, forKey: .number)
        try container.encode(name, forKey: .name)
        try container.encode(keywords, forKey: .keywords)
        try container.encode(generalMeanings, forKey: .generalMeanings)
        try container.encode(astrologicalInfluence, forKey: .astrologicalInfluence)
        try container.encode(archetypeFigure, forKey: .archetypeFigure)
        try container.encode(spiritualPlane, forKey: .spiritualPlane)
        try container.encode(mentalPlane, forKey: .mentalPlane)
        try container.encode(emotionalPlane, forKey: .emotionalPlane)
        try container.encode(materialPlane, forKey: .materialPlane)
        try container.encode(physicalPlane, forKey: .physicalPlane)
        try container.encode(positivePoints, forKey: .positivePoints)
        try container.encode(negativePoints, forKey: .negativePoints)
        try container.encode(yearPrediction, forKey: .yearPrediction)
        try container.encode(time, forKey: .time)
    }
}
