import { CALL_API, apiEvents } from './../../../middlewares/api'

export const OAUTH_PROVIDERS_ENDPOINT = 'oauth_providers'
export const OAUTH_PROVIDERS_ENDPOINT_NAME = 'OAUTH_PROVIDERS'

export const toggleDialog = () => {
  return {
    type: TOGGLE_LOGIN
  }
}

export const selectLogin = () => {
  return {
    type: SELECT_LOGIN
  }
}

export const selectSignup = () => {
  return {
    type: SELECT_SIGNUP
  }
}

export const getProviders = (options) => ({
  [CALL_API]: {
    types: apiEvents(OAUTH_PROVIDERS_ENDPOINT_NAME),
    endpoint: OAUTH_PROVIDERS_ENDPOINT,
    name: OAUTH_PROVIDERS_ENDPOINT_NAME,
    options: {...options, method: 'get'}
  }
})
