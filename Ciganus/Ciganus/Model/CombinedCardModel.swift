//
//  CombinedCardModel.swift
//  Ciganus
//
//  Created by Fernando Marins on 13/04/25.
//

import Foundation

struct CombinedCardModel: Decodable {
    let number: String
    let description: String
}

class CombinedCards {
    enum JSONReadingError: Error {
        case fileNotFound
        case invalidData
        case jsonDecodingFailed(Error)
    }

    func getCombinedCards() throws -> [CombinedCardModel] {
        return try readJSONFromFile(filename: "cards_data")
    }

    private func readJSONFromFile(filename: String) throws -> [CombinedCardModel] {
        guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw JSONReadingError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode([CombinedCardModel].self, from: data)
            return decodedObject
        } catch {
            if let decodingError = error as? JSONReadingError {
                throw decodingError
            } else {
                throw JSONReadingError.jsonDecodingFailed(error)
            }
        }
    }
}
