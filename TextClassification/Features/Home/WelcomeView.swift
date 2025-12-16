//
//  WelcomeView.swift
//  TextClassification
//
//  Created by Vinicius Silva Moreira on 15/12/25.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = AppViewModel()

    var body: some View {
        NavigationSplitView {
            sessionList
                .navigationTitle("Histórico")
                .toolbar { toolbarContent }
        } detail: {
            Text("Selecione um chat")
                .foregroundStyle(.secondary)
        }
        .onAppear {
            viewModel.loadSessions()
        }
    }
}

private extension WelcomeView {
    
    @ViewBuilder
    var sessionList: some View {
        List {
            if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red).font(.caption)
            }
            
            ForEach(viewModel.sessions) { session in
                NavigationLink {
                    ChatView(
                        sessionId: session.id,
                        sessionTitle: session.title,
                        onUpdate: { viewModel.loadSessions() }
                    )
                } label: {
                    sessionRow(for: session)
                }
            }
            .onDelete(perform: viewModel.deleteSession)
        }
    }
    
    @ViewBuilder
    func sessionRow(for session: ChatSession) -> some View {
        VStack(alignment: .leading) {
            Text(session.title)
                .font(.headline)
                .lineLimit(1)
            
            Text(session.timestamp.formatted(date: .numeric, time: .shortened))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton()
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: viewModel.addNewSession) {
                Label("Novo", systemImage: "plus")
            }
        }
    }
}

#Preview {
    WelcomeView()
}
