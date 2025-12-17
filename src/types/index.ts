export interface ChatSession {
    id: string;
    title: string;
    timestamp: number;
}

export interface ChatMessage {
    id: string;
    text: string;
    isUser: boolean;
    timestamp: number;

    // MARK: - coreml
    label?: string;
    confidenceFake?: number;
    confidenceReal?: number;
}