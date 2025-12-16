//
//  DatabaseManager.swift
//  TextClassification
//
//  Created by Vinicius Silva Moreira on 16/12/25.
//

import Foundation
import SQLite

enum DatabaseError: Error {
    case connectionFailed
}

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private var db: Connection?
    
    // MARK: - tables
    
    private let sessionsTable = Table("sessions")
    private let messagesTable = Table("messages")
    
    // MARK: - session columns
    
    private let id = Expression<String>("id")
    private let title = Expression<String>("title")
    private let timestamp = Expression<Date>("timestamp")
    
    // MARK: - message columns
    
    private let sessionId = Expression<String>("sessionId")
    private let text = Expression<String>("text")
    private let isUser = Expression<Bool>("isUser")
    private let label = Expression<String?>("label")
    private let fakeConf = Expression<Double?>("fakeConf")
    private let realConf = Expression<Double?>("realConf")
    
    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            
            db = try Connection("\(path)/db.sqlite3")
            try createTables()
        } catch {
            print(error)
        }
    }
    
    private func createTables() throws {
        guard let db = db else { return }
        
        try db.run(sessionsTable.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(title)
            t.column(timestamp)
        })
        
        try db.run(messagesTable.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(sessionId)
            t.column(text)
            t.column(isUser)
            t.column(timestamp)
            t.column(label)
            t.column(fakeConf)
            t.column(realConf)
            t.foreignKey(sessionId, references: sessionsTable, id, delete: .cascade)
        })
    }
    
    // MARK: - session funcs
    
    func createSession(title: String) throws -> ChatSession {
        guard let db = db else { throw DatabaseError.connectionFailed }
        
        let newId = UUID().uuidString
        let now = Date()
        
        let insert = sessionsTable.insert(id <- newId, self.title <- title, timestamp <- now)
        try db.run(insert)
        
        return ChatSession(id: newId, title: title, timestamp: now)
    }
    
    func getAllSessions() throws -> [ChatSession] {
        guard let db = db else { throw DatabaseError.connectionFailed }
        
        var list: [ChatSession] = []
        // Removemos o '!' e usamos o 'try' do throws
        for row in try db.prepare(sessionsTable.order(timestamp.desc)) {
            list.append(ChatSession(
                id: row[id],
                title: row[title],
                timestamp: row[timestamp]
            ))
        }
        return list
    }
    
    // MARK: - message funcs
    
    func addMessage(sessionId: String, text: String, isUser: Bool, label: String? = nil, fConf: Double? = nil, rConf: Double? = nil) throws -> ChatMessage {
        guard let db = db else { throw DatabaseError.connectionFailed }
        
        let newId = UUID().uuidString
        let now = Date()
        
        let insert = messagesTable.insert(
            id <- newId,
            self.sessionId <- sessionId,
            self.text <- text,
            self.isUser <- isUser,
            timestamp <- now,
            self.label <- label,
            fakeConf <- fConf,
            realConf <- rConf
        )
        try db.run(insert)
        
        return ChatMessage(id: newId, sessionId: sessionId, text: text, isUser: isUser, timestamp: now, label: label, confidenceFake: fConf, confidenceReal: rConf)
    }
    
    func getMessages(for sessionID: String) throws -> [ChatMessage] {
        guard let db = db else { throw DatabaseError.connectionFailed }
        
        var list: [ChatMessage] = []
        let query = messagesTable.filter(sessionId == sessionID).order(timestamp.asc)
        
        for row in try db.prepare(query) {
            list.append(ChatMessage(
                id: row[id],
                sessionId: row[sessionId],
                text: row[text],
                isUser: row[isUser],
                timestamp: row[timestamp],
                label: row[label],
                confidenceFake: row[fakeConf],
                confidenceReal: row[realConf]
            ))
        }
        return list
    }
    
    func deleteSession(id: String) throws {
        guard let db = db else { throw DatabaseError.connectionFailed }
        let session = sessionsTable.filter(self.id == id)
        try db.run(session.delete())
    }
    
    func updateSessionTitle(id: String, newTitle: String) throws {
        guard let db = db else { throw DatabaseError.connectionFailed }
        let session = sessionsTable.filter(self.id == id)
        try db.run(session.update(title <- newTitle))
    }
}
