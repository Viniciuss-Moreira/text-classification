import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import Icon from 'react-native-vector-icons/Ionicons';
import { ChatSession } from '../types';

interface ChatListItemProps {
    item: ChatSession;
    isEditing: boolean;
    isSelected: boolean;
    onPress: () => void;
    onSelect: () => void;
    onDelete: () => void;
}

export const ChatListItem = ({ item, isEditing, isSelected, onPress, onSelect, onDelete }: ChatListItemProps) => {

    const handlePress = () => {
        if (isEditing) {
            onSelect();
        } else {
            onPress();
        }
    };

    return (
        <View style={styles.itemContainer}>
            <TouchableOpacity
                activeOpacity={0.8}
                onPress={handlePress}
                style={styles.leftArea}
            >
                {isEditing ? (
                    <Icon
                        name={isSelected ? "checkmark-circle" : "ellipse-outline"}
                        size={24}
                        color={isSelected ? "#007AFF" : "#C7C7CC"}
                    />
                ) : (
                    <View style={styles.avatar}>
                        <Icon name="chatbubble-ellipses" size={24} color="#007AFF" />
                    </View>
                )}
            </TouchableOpacity>

            <TouchableOpacity
                style={styles.textContainer}
                disabled={isEditing}
                activeOpacity={0.7}
                onPress={onPress}
            >
                <Text style={styles.title} numberOfLines={1}>{item.title}</Text>
                <Text style={styles.date}>
                    {new Date(item.timestamp).toLocaleDateString()}
                </Text>
            </TouchableOpacity>

            {isEditing ? (
                isSelected ? (
                    <TouchableOpacity onPress={onDelete} style={styles.deleteButton}>
                        <Icon name="trash" size={24} color="#FF3B30" />
                    </TouchableOpacity>
                ) : (
                    <View style={styles.placeholderRight} />
                )
            ) : (
                <Icon name="chevron-forward" size={20} color="#C7C7CC" style={{ marginRight: 8 }} />
            )}
        </View>
    );
};

const styles = StyleSheet.create({
    itemContainer: {
        flexDirection: 'row', alignItems: 'center',
        paddingVertical: 12, paddingHorizontal: 16, backgroundColor: '#fff'
    },
    leftArea: {
        paddingRight: 12, justifyContent: 'center', alignItems: 'center', minWidth: 40
    },
    avatar: {
        width: 40, height: 40, borderRadius: 20,
        backgroundColor: '#F2F2F7', justifyContent: 'center', alignItems: 'center',
    },
    textContainer: { flex: 1, justifyContent: 'center' },
    title: { fontSize: 17, fontWeight: '600', color: '#000', marginBottom: 3 },
    date: { fontSize: 14, color: '#8E8E93' },
    placeholderRight: { width: 30 },
    deleteButton: { padding: 8, marginLeft: 5 },
});