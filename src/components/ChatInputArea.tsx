import React, { useState } from 'react';
import {
    View,
    TextInput,
    TouchableOpacity,
    ActivityIndicator,
    StyleSheet
} from 'react-native';
import Icon from 'react-native-vector-icons/Ionicons';

interface ChatInputAreaProps {
    onSend: (text: string) => void;
    isLoading: boolean;
    placeholder: string;
}

export const ChatInputArea = ({ onSend, isLoading, placeholder }: ChatInputAreaProps) => {
    const [text, setText] = useState('');

    const handlePress = () => {
        if (!text.trim()) return;
        onSend(text);
        setText('');
    };

    return (
        <View style={styles.inputArea}>
            <TextInput
                style={styles.input}
                placeholder={placeholder}
                value={text}
                onChangeText={setText}
                multiline
                maxLength={500}
            />
            <TouchableOpacity
                style={styles.sendButton}
                onPress={handlePress}
                disabled={isLoading || !text.trim()}
            >
                {isLoading ? (
                    <ActivityIndicator color="#fff" size="small" />
                ) : (
                    <Icon name="arrow-up" size={20} color="#fff" />
                )}
            </TouchableOpacity>
        </View>
    );
};

const styles = StyleSheet.create({
    inputArea: {
        flexDirection: 'row',
        padding: 10,
        borderTopWidth: 1,
        borderColor: '#eee',
        backgroundColor: '#f9f9f9',
        alignItems: 'flex-end'
    },
    input: {
        flex: 1,
        minHeight: 36,
        maxHeight: 100,
        backgroundColor: '#fff',
        borderWidth: 1,
        borderColor: '#ddd',
        borderRadius: 18,
        paddingHorizontal: 15,
        paddingVertical: 8,
        marginRight: 10,
        fontSize: 16
    },
    sendButton: {
        backgroundColor: '#007AFF',
        width: 36, height: 36, borderRadius: 18,
        justifyContent: 'center', alignItems: 'center',
        marginBottom: 2
    }
});