//
//  ChatModule.swift
//  TextClassification
//
//  Created by Vinicius Silva Moreira on 16/12/25.
//

import Foundation

@objc(ChatModule)
class ChatModule: NSObject {
    
    @objc static func requiresMainQueueSetup() -> Bool {
        return false
    }

    @objc(getMessages:resolver:rejecter:)
    func getMessages(_ sessionId: String, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            let messages = try DatabaseManager.shared.getMessages(for: sessionId)
            // Lembre-se: sua struct ChatMessage precisa ter a extensão .toDictionary
            let data = messages.map { $0.toDictionary }
            resolver(data)
        } catch {
            rejecter("DB_ERROR", "Error to retrieve messages", error)
        }
    }

  @objc(sendMessage:text:resolver:rejecter:)
      func sendMessage(_ sessionId: String, text: String, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
          do {
              _ = try DatabaseManager.shared.addMessage(sessionId: sessionId, text: text, isUser: true)
              
              var botText = "Erro ao analisar."
              var label: String? = nil
              var confFake: Double? = nil
              var confReal: Double? = nil
              
              if let result = ClassifierManager.shared.predict(text) {
                  botText = result.label.uppercased()
                  
                  label = result.label
                  confFake = result.confidenceFake
                  confReal = result.confidenceReal
              }

              _ = try DatabaseManager.shared.addMessage(
                  sessionId: sessionId,
                  text: botText,
                  isUser: false,
                  label: label,
                  confidenceFake: confFake,
                  confidenceReal: confReal
              )

              let updatedMessages = try DatabaseManager.shared.getMessages(for: sessionId)
              let data = updatedMessages.map { $0.toDictionary }
              
              resolver(data)
              
          } catch {
              rejecter("SEND_ERROR", "Error to process messages", error)
          }
      }
  
    @objc(createSession:resolver:rejecter:)
    func createSession(_ title: String, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            let session = try DatabaseManager.shared.createSession(title: title)
            
            let sessionDict: [String: Any] = [
                "id": session.id,
                "title": session.title,
                "timestamp": session.timestamp.timeIntervalSince1970 * 1000
            ]
            
            resolver(sessionDict)
        } catch {
            rejecter("CREATE_ERROR", "Error to create session", error)
        }
    }

    @objc(getAllSessions:rejecter:)
    func getAllSessions(_ resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            let sessions = try DatabaseManager.shared.getAllSessions()
            
            let data = sessions.map { session in
                return [
                    "id": session.id,
                    "title": session.title,
                    "timestamp": session.timestamp.timeIntervalSince1970 * 1000
                ]
            }
            
            resolver(data)
        } catch {
            rejecter("LIST_ERROR", "Error to list sessions", error)
        }
    }
  
  @objc(deleteSession:resolver:rejecter:)
      func deleteSession(_ sessionId: String, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
          do {
              try DatabaseManager.shared.deleteSession(id: sessionId)
              resolver(true)
          } catch {
              rejecter("DELETE_ERROR", "Error to delete session", error)
          }
      }

      @objc(updateSessionTitle:title:resolver:rejecter:)
      func updateSessionTitle(_ sessionId: String, title: String, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
          do {
              try DatabaseManager.shared.updateSessionTitle(id: sessionId, newTitle: title)
              resolver(true)
          } catch {
              rejecter("UPDATE_ERROR", "Error to update title", error)
          }
      }
}
