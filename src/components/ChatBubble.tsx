import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useTranslation } from 'react-i18next';
import Icon from 'react-native-vector-icons/Ionicons';
import { ChatMessage } from '../types';

interface ChatBubbleProps {
    message: ChatMessage;
}

export const ChatBubble = ({ message }: ChatBubbleProps) => {
    const { t } = useTranslation();
    const isUser = message.isUser;
    const isAnalysisResult = !isUser && (message.text === 'FAKE' || message.text === 'REAL');

    const renderBadge = () => {
        if (isUser || message.confidenceFake === undefined) return null;

        const isFake = (message.confidenceFake || 0) > (message.confidenceReal || 0);

        const label = isFake ? t('chat.fake') : t('chat.real');
        const color = isFake ? '#d32f2f' : '#388e3c';
        const iconName = isFake ? 'alert-circle' : 'checkmark-circle';

        const containerStyle = isAnalysisResult
            ? styles.badgeContainerLarge
            : styles.badgeContainerSmall;

        const textStyle = isAnalysisResult
            ? styles.badgeTextLarge
            : styles.badgeTextSmall;

        return (
            <View style={containerStyle}>
                <Icon
                    name={iconName}
                    size={isAnalysisResult ? 24 : 14}
                    color={color}
                    style={{ marginRight: 6 }}
                />
                <Text style={[textStyle, { color: color }]}>
                    {label}
                </Text>
            </View>
        );
    };

    return (
        <View style={[styles.row, isUser ? styles.rowUser : styles.rowBot]}>

            {!isUser && (
                <View style={[
                    styles.avatarContainer,
                    isAnalysisResult && { marginBottom: 0 }
                ]}>
                    <Icon name="sparkles" size={24} color="#8E8E93" />
                </View>
            )}

            <View style={[styles.contentContainer, isUser ? styles.contentUser : styles.contentBot]}>

                {!isAnalysisResult && (
                    <View style={[styles.bubble, isUser ? styles.userBubble : styles.botBubble]}>
                        <Text style={[styles.text, isUser ? styles.userText : styles.botText]}>
                            {message.text}
                        </Text>
                    </View>
                )}

                {renderBadge()}

            </View>
        </View>
    );
};

const styles = StyleSheet.create({
    row: {
        flexDirection: 'row',
        marginBottom: 16,
        alignItems: 'flex-end',
    },
    rowUser: { justifyContent: 'flex-end' },
    rowBot: { justifyContent: 'flex-start' },

    avatarContainer: {
        width: 32,
        height: 32,
        justifyContent: 'center',
        alignItems: 'center',
        marginRight: 8,
        marginBottom: 4,
    },

    contentContainer: { maxWidth: '85%' },
    contentUser: { alignItems: 'flex-end' },
    contentBot: { alignItems: 'flex-start', justifyContent: 'center' },

    bubble: {
        padding: 12,
        borderRadius: 16,
    },
    userBubble: {
        backgroundColor: '#007AFF',
        borderBottomRightRadius: 2,
    },
    botBubble: {
        backgroundColor: '#F2F2F7',
        borderBottomLeftRadius: 2,
    },
    text: { fontSize: 16, lineHeight: 22 },
    userText: { color: '#fff' },
    botText: { color: '#000' },

    badgeContainerSmall: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: 4,
        marginLeft: 2,
    },
    badgeTextSmall: {
        fontSize: 11,
        fontWeight: 'bold',
        textTransform: 'uppercase'
    },

    badgeContainerLarge: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingVertical: 8,
        paddingHorizontal: 12,
        backgroundColor: '#fff',
        borderRadius: 20,
        borderWidth: 1,
        borderColor: '#f0f0f0',
        shadowColor: "#000",
        shadowOffset: { width: 0, height: 1 },
        shadowOpacity: 0.1,
        shadowRadius: 2,
        elevation: 2,
    },
    badgeTextLarge: {
        fontSize: 14,
        fontWeight: '900',
        textTransform: 'uppercase'
    }
});