//
//  ChatViewModel.swift
//  TextClassification
//
//  Created by Vinicius Silva Moreira on 16/12/25.
//

import SwiftUI
import Combine

class ChatViewModel: ObservableObject {
    // MARK: - Properties
    let sessionId: String
    private var onUpdateList: (() -> Void)?
    
    @Published var sessionTitle: String
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isSending: Bool = false
    
    // MARK: - Init
    init(sessionId: String, sessionTitle: String, onUpdate: (() -> Void)? = nil) {
        self.sessionId = sessionId
        self.sessionTitle = sessionTitle
        self.onUpdateList = onUpdate
        loadMessages()
    }
    
    // MARK: - Logic
    func loadMessages() {
        do {
            messages = try DatabaseManager.shared.getMessages(for: sessionId)
        } catch {
            print(error)
        }
    }
    
    func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        let textToAnalyze = inputText
        inputText = ""
        
        do {
            if messages.isEmpty {
                let newTitle = String(textToAnalyze.prefix(30))
                try DatabaseManager.shared.updateSessionTitle(id: sessionId, newTitle: newTitle)
                
                DispatchQueue.main.async {
                    self.sessionTitle = newTitle
                    self.onUpdateList?()
                }
            }
            
            let userMsg = try DatabaseManager.shared.addMessage(sessionId: sessionId, text: textToAnalyze, isUser: true)
            messages.append(userMsg)
            
            isSending = true
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let result = ClassifierManager.shared.predict(textToAnalyze)
                
                DispatchQueue.main.async {
                    self?.processBotResponse(result)
                    self?.isSending = false
                }
            }
            
        } catch {
            print(error)
            inputText = textToAnalyze
        }
    }
    
    private func processBotResponse(_ result: ClassificationResult?) {
        var botText = ""
        var label: String? = nil
        var fConf: Double? = nil
        var rConf: Double? = nil
        
        if let res = result {
            let isFake = res.label.lowercased() == "fake"
            let icon = isFake ? "🚨" : "✅"
            let textoResultado = isFake ? "FAKE" : "REAL"
            
            botText = "\(icon) Resultado: \(textoResultado)"
            label = res.label
            fConf = res.confidenceFake
            rConf = res.confidenceReal
        }
        
        do {
            let botMsg = try DatabaseManager.shared.addMessage(
                sessionId: sessionId,
                text: botText,
                isUser: false,
                label: label,
                fConf: fConf,
                rConf: rConf
            )
            withAnimation {
                messages.append(botMsg)
            }
        } catch {
            print(error)
        }
    }
}
