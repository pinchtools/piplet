import React from 'react'
import { IntlProvider, addLocaleData } from 'react-intl'
import en from 'react-intl/locale-data/en'
import fr from 'react-intl/locale-data/fr'

// Our translated strings
import localeData from './../../build/locales.json'

addLocaleData([...en, ...fr])

// Define user's language. Different browsers have the user locale defined
// on different fields on the `navigator` object, so we make sure to account
// for these different by checking all of them
const language = (navigator.languages && navigator.languages[0]) ||
  navigator.language ||
  navigator.userLanguage

// Split locales with a region code
const languageWithoutRegionCode = language.toLowerCase().split(/[_-]+/)[0]

// Try full locale, try locale without region code, fallback to 'en'
const messages = localeData[languageWithoutRegionCode] || localeData[language] || localeData.en

const Intl = (props) => (
  <IntlProvider locale={language} messages={messages}>
    {props.children}
  </IntlProvider>
)

export default Intl
