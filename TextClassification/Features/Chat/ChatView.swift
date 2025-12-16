//
//  ChatView.swift
//  TextClassification
//
//  Created by Vinicius Silva Moreira on 16/12/25.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @FocusState private var isFocused: Bool
    
    init(sessionId: String, sessionTitle: String, onUpdate: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(
            sessionId: sessionId,
            sessionTitle: sessionTitle,
            onUpdate: onUpdate
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            messagesListArea
            inputArea
        }
        .navigationTitle(viewModel.sessionTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension ChatView {
    
    @ViewBuilder
    var messagesListArea: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.messages) { msg in
                        MessageBubble(message: msg)
                    }
                }
                .padding()
            }
            .onChange(of: viewModel.messages.count) {
                if let last = viewModel.messages.last {
                    withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }
        }
    }
    
    @ViewBuilder
    var inputArea: some View {
        HStack(spacing: 12) {
            TextField("Cole a manchete...", text: $viewModel.inputText)
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
                .onSubmit {
                    viewModel.sendMessage()
                    isFocused = false
                }
                .disabled(viewModel.isSending)
            
            Button(action: {
                viewModel.sendMessage()
                isFocused = false
            }) {
                if viewModel.isSending {
                    ProgressView()
                } else {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(canSend ? .blue : .gray)
                }
            }
            .disabled(!canSend)
        }
        .padding()
        .background(.bar)
    }
    
    var canSend: Bool {
        !viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !viewModel.isSending
    }
}

#Preview {
    NavigationStack {
        ChatView(sessionId: "mock", sessionTitle: "Preview Chat")
    }
}
