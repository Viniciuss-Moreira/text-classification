//
//  ChatModule.swift
//  TextClassification
//
//  Created by Vinicius Silva Moreira on 16/12/25.
//

// ChatModule.swift
import Foundation
import React // Certifique-se de que o React está instalado no projeto

@objc(ChatModule)
class ChatModule: NSObject {
    
    // O React Native requer que essa função retorne true se você usar main thread, false se não.
    @objc static func requiresMainQueueSetup() -> Bool {
        return false
    }

    // 1. Buscar Mensagens
    @objc(getMessages:resolver:rejecter:)
    func getMessages(_ sessionId: String, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            let messages = try DatabaseManager.shared.getMessages(for: sessionId)
            // Converte [ChatMessage] para [[String: Any]]
            let data = messages.map { $0.toDictionary }
            resolver(data) // Devolve pro JS
        } catch {
            rejecter("DB_ERROR", "Erro ao buscar mensagens", error)
        }
    }

    // 2. Enviar Mensagem (A lógica pesada fica aqui)
    @objc(sendMessage:text:resolver:rejecter:)
    func sendMessage(_ sessionId: String, text: String, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            // A. Salva User Msg
            _ = try DatabaseManager.shared.addMessage(sessionId: sessionId, text: text, isUser: true)
            
            // B. Atualiza título se necessário (simplificado para exemplo)
            // ... lógica de updateSessionTitle aqui ...

            // C. IA Predict (Síncrono para simplificar a ponte, ou use GCD e callback)
            // Nota: Em produção, cuidado ao bloquear a thread. Aqui vamos fazer direto.
            var botText = "Erro"
            if let result = ClassifierManager.shared.predict(text) {
                let isFake = result.label.lowercased() == "fake"
                let icon = isFake ? "🚨" : "✅"
                let veredito = isFake ? "FAKE" : "REAL"
                botText = "\(icon) Resultado: \(veredito)"
            }

            // D. Salva Bot Msg
            _ = try DatabaseManager.shared.addMessage(sessionId: sessionId, text: botText, isUser: false)

            // E. Retorna a lista atualizada para o JS renderizar tudo de novo
            let updatedMessages = try DatabaseManager.shared.getMessages(for: sessionId)
            let data = updatedMessages.map { $0.toDictionary }
            
            resolver(data) // Sucesso!
            
        } catch {
            rejecter("SEND_ERROR", "Erro ao processar mensagem", error)
        }
    }
}
