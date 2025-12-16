//
//  MessageBubble.swift
//  TextClassification
//
//  Created by Vinicius Silva Moreira on 16/12/25.
//

import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading) {
                Text(message.text)
                    .padding()
                    .background(message.isUser ? Color.blue : Color(.systemGray5))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(16)
                
                Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 4)
            }
            .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser { Spacer() }
        }
    }
}

#Preview {
    VStack {
        MessageBubble(message: ChatMessage(
            id: UUID().uuidString,
            sessionId: "preview",
            text: "Donald Trump construct biggest wall in 50 years",
            isUser: true,
            timestamp: Date()
        ))
        
        MessageBubble(message: ChatMessage(
            id: UUID().uuidString,
            sessionId: "preview",
            text: "❌ Result: FAKE",
            isUser: false,
            timestamp: Date()
        ))
    }
}
