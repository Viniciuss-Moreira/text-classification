//
//  DataBaseViewModel.swift
//  TextClassification
//
//  Created by Vinicius Silva Moreira on 16/12/25.
//

import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var sessions: [ChatSession] = []
    @Published var errorMessage: String? = nil
    
    init() {
        loadSessions()
    }
    
    func loadSessions() {
        do {
            sessions = try DatabaseManager.shared.getAllSessions()
        } catch {
            print(error)
        }
    }
    
    func addNewSession() {
        do {
            _ = try DatabaseManager.shared.createSession(title: "New Chat")
            loadSessions()
        } catch {
            print(error)
        }
    }
    
    func deleteSession(at offsets: IndexSet) {
        for index in offsets {
            let session = sessions[index]
            do {
                try DatabaseManager.shared.deleteSession(id: session.id)
            } catch {
                print(error)
            }
        }
        loadSessions()
    }
}
