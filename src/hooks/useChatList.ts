import { useState, useEffect } from 'react';
import { NativeModules, Alert, LayoutAnimation, Platform, UIManager } from 'react-native';
import { useIsFocused } from '@react-navigation/native';
import { useTranslation } from 'react-i18next';
import { ChatSession } from '../types';

const { ChatModule } = NativeModules;

if (Platform.OS === 'android' && UIManager.setLayoutAnimationEnabledExperimental) {
    UIManager.setLayoutAnimationEnabledExperimental(true);
}

export const useChatList = (navigation: any) => {
    const { t } = useTranslation();
    const isFocused = useIsFocused();

    const [sessions, setSessions] = useState<ChatSession[]>([]);
    const [isEditing, setIsEditing] = useState(false);
    const [selectedIds, setSelectedIds] = useState<string[]>([]);

    useEffect(() => {
        if (isFocused) loadSessions();
    }, [isFocused]);

    const loadSessions = async () => {
        try {
            const data = await ChatModule.getAllSessions();
            setSessions(data.sort((a: any, b: any) => b.timestamp - a.timestamp));
        } catch (e) {
            console.error(e);
        }
    };

    const createNewSession = async () => {
        try {
            const newSession = await ChatModule.createSession(t('home.newChat'));
            navigation.navigate('Chat', { sessionId: newSession.id, title: newSession.title });
        } catch (e) {
            Alert.alert(t('common.error'), t('home.createError'));
        }
    };

    const toggleEditMode = () => {
        LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
        setIsEditing(!isEditing);
        setSelectedIds([]);
    };

    const toggleSelection = (id: string) => {
        LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
        if (selectedIds.includes(id)) {
            setSelectedIds(prev => prev.filter(itemId => itemId !== id));
        } else {
            setSelectedIds(prev => [...prev, id]);
        }
    };

    const handleDelete = (id: string) => {
        Alert.alert(
            t('home.deleteAlertTitle'),
            t('home.deleteAlertMsg'),
            [
                { text: t('common.cancel'), style: "cancel" },
                {
                    text: t('common.delete'),
                    style: "destructive",
                    onPress: async () => {
                        await ChatModule.deleteSession(id);
                        LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
                        loadSessions();
                        setSelectedIds(prev => prev.filter(itemId => itemId !== id));
                    }
                }
            ]
        );
    };

    return {
        sessions,
        isEditing,
        selectedIds,
        createNewSession,
        toggleEditMode,
        toggleSelection,
        handleDelete
    };
};