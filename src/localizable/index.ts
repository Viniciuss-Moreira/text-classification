import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import * as RNLocalize from 'react-native-localize';
import 'intl-pluralrules';
import pt from './pt';
import en from './en';

const locales = RNLocalize.getLocales();
const systemLanguage = locales[0]?.languageCode;

i18n
    .use(initReactI18next)
    .init({
        compatibilityJSON: 'v4',

        lng: systemLanguage,
        fallbackLng: 'pt',
        debug: true,

        resources: {
            pt: { translation: pt },
            en: { translation: en },

            'pt-BR': { translation: pt },
            'pt-PT': { translation: pt },
            'en-US': { translation: en },
            'en-GB': { translation: en },
        },

        interpolation: {
            escapeValue: false
        }
    });

export default i18n;