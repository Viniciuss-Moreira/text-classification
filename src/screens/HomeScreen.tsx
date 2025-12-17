import React, { useLayoutEffect } from 'react';
import {
    View,
    Text,
    FlatList,
    TouchableOpacity,
    StyleSheet,
    StatusBar
} from 'react-native';
import { useNavigation } from '@react-navigation/native';
import Icon from 'react-native-vector-icons/Ionicons';
import { useTranslation } from 'react-i18next';
import { ChatListItem } from '../components/ChatListItem';
import { useChatList } from '../hooks/useChatList';

export default function HomeScreen() {
    const { t } = useTranslation();
    const navigation = useNavigation<any>();

    const {
        sessions, isEditing, selectedIds,
        createNewSession, toggleEditMode, toggleSelection, handleDelete
    } = useChatList(navigation);

    useLayoutEffect(() => {
        navigation.setOptions({
            title: t('home.title'),
            headerRight: () => (
                <View style={styles.headerRightContainer}>
                    <TouchableOpacity
                        onPress={toggleEditMode}
                        style={styles.editBtn}
                        activeOpacity={0.6}
                    >
                        <Text style={styles.headerBtnText}>
                            {isEditing ? t('home.done') : t('home.edit')}
                        </Text>
                    </TouchableOpacity>

                    {!isEditing && (
                        <TouchableOpacity
                            onPress={createNewSession}
                            style={styles.plusBtn}
                            activeOpacity={0.6}
                        >
                            <Icon name="add-circle" size={28} color="#007AFF" />
                        </TouchableOpacity>
                    )}
                </View>
            ),
        });
    }, [navigation, isEditing, t]);

    return (
        <View style={styles.container}>
            <StatusBar barStyle="dark-content" backgroundColor="#fff" />

            <FlatList
                data={sessions}
                keyExtractor={(item) => item.id}
                ItemSeparatorComponent={() => <View style={styles.separator} />}
                contentContainerStyle={styles.listContent}

                renderItem={({ item }) => (
                    <ChatListItem
                        item={item}
                        isEditing={isEditing}
                        isSelected={selectedIds.includes(item.id)}
                        onPress={() => navigation.navigate('Chat', { sessionId: item.id, title: item.title })}
                        onSelect={() => toggleSelection(item.id)}
                        onDelete={() => handleDelete(item.id)}
                    />
                )}

                ListEmptyComponent={
                    <View style={styles.emptyState}>
                        <Text style={styles.emptyText}>{t('home.emptyState')}</Text>
                    </View>
                }
            />
        </View>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1, backgroundColor: '#fff' },
    listContent: { paddingBottom: 20 },

    headerRightContainer: {
        flexDirection: 'row', alignItems: 'center', minWidth: 80, justifyContent: 'flex-end'
    },
    editBtn: {
        paddingVertical: 6, paddingHorizontal: 12, backgroundColor: 'transparent'
    },
    plusBtn: { padding: 4, marginLeft: 6 },
    headerBtnText: { color: '#007AFF', fontSize: 17, fontWeight: '600' },

    separator: { height: 1, backgroundColor: '#E5E5EA', marginLeft: 78 },
    emptyState: { alignItems: 'center', marginTop: 50 },
    emptyText: { color: '#999' }
});