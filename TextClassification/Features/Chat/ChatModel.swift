//
//  Item.swift
//  TextClassification
//
//  Created by Vinicius Silva Moreira on 15/12/25.
//

import Foundation

struct ChatSession: Identifiable, Codable {
    var id: String
    var title: String
    var timestamp: Date
}

struct ChatMessage: Identifiable, Codable {
    var id: String
    var sessionId: String
    var text: String
    var isUser: Bool
    var timestamp: Date
    
// MARK: - model data
    
    var label: String?
    var confidenceFake: Double?
    var confidenceReal: Double?
}

extension ChatMessage {
    // Transforma a Struct em algo que o JS entende
    var toDictionary: [String: Any] {
        return [
            "id": id,
            "text": text,
            "isUser": isUser,
            // O JS prefere timestamp em milissegundos ou string ISO
            "timestamp": timestamp.timeIntervalSince1970 * 1000
        ]
    }
}
