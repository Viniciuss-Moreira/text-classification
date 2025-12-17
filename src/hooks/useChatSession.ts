import { useState, useEffect } from 'react';
import { NativeModules, Alert } from 'react-native';
import { useTranslation } from 'react-i18next';
import { ChatMessage } from '../types';

const { ChatModule } = NativeModules;

export const useChatSession = (sessionId: string, navigation: any) => {
    const { t } = useTranslation();
    const [messages, setMessages] = useState<ChatMessage[]>([]);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        loadMessages();
    }, []);

    const loadMessages = async () => {
        try {
            const data = await ChatModule.getMessages(sessionId);
            setMessages(data);
        } catch (e) {
            console.error("Erro ao carregar mensagens:", e);
        }
    };

    const sendMessage = async (text: string) => {
        if (!text.trim()) return;

        setLoading(true);
        try {
            const updatedList = await ChatModule.sendMessage(sessionId, text);
            setMessages(updatedList);

            if (updatedList.length <= 2) {
                await ChatModule.updateSessionTitle(sessionId, text);
                navigation.setOptions({ title: text });
            }
        } catch (e) {
            Alert.alert(t('common.error'), t('chat.sendError'));
        } finally {
            setLoading(false);
        }
    };

    return {
        messages,
        loading,
        sendMessage,
        refreshMessages: loadMessages
    };
};