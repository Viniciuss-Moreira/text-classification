import React, { useRef } from 'react';
import {
    SafeAreaView,
    FlatList,
    StyleSheet,
    KeyboardAvoidingView,
    Platform
} from 'react-native';
import { useRoute, useNavigation } from '@react-navigation/native';
import { useTranslation } from 'react-i18next';

import { ChatBubble } from '../components/ChatBubble';
import { ChatInputArea } from '../components/ChatInputArea';
import { useChatSession } from '../hooks/useChatSession';

export default function ChatScreen() {
    const { t } = useTranslation();
    const route = useRoute<any>();
    const navigation = useNavigation();
    const flatListRef = useRef<FlatList>(null);

    const { messages, loading, sendMessage } = useChatSession(route.params.sessionId, navigation);

    return (
        <SafeAreaView style={styles.container}>
            <KeyboardAvoidingView
                behavior={Platform.OS === 'ios' ? 'padding' : undefined}
                style={styles.keyboardView}
            >
                <FlatList
                    ref={flatListRef}
                    data={messages}
                    keyExtractor={(item) => item.id}
                    renderItem={({ item }) => <ChatBubble message={item} />}
                    contentContainerStyle={styles.list}
                    onContentSizeChange={() => flatListRef.current?.scrollToEnd()}
                />

                <ChatInputArea
                    onSend={sendMessage}
                    isLoading={loading}
                    placeholder={t('chat.placeholder')}
                />
            </KeyboardAvoidingView>
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1, backgroundColor: '#fff' },
    keyboardView: { flex: 1 },
    list: { padding: 15, paddingBottom: 20 },
});