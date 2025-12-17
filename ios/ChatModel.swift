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
    var toDictionary: [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "text": text,
            "isUser": isUser,
            "timestamp": timestamp.timeIntervalSince1970 * 1000
        ]
        if let l = label { dict["label"] = l }
        if let cf = confidenceFake { dict["confidenceFake"] = cf }
        if let cr = confidenceReal { dict["confidenceReal"] = cr }
        return dict
    }
}
