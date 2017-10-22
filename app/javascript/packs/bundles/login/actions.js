import { CALL_API, apiEvents } from './../../middlewares/api'

export const TOGGLE_LOGIN = 'TOGGLE_LOGIN'
export const SELECT_LOGIN = 'SELECT_LOGIN'
export const SELECT_SIGNUP = 'SELECT_SIGNUP'

export const LOGIN_FORM = 'login'
export const SIGNUP_FORM = 'signup'
export const DEFAULT_VISIBILITY = false

export const LOGIN_ENDPOINT = 'tokens'
export const LOGIN_ENDPOINT_NAME = 'LOGIN'

export const SIGNUP_ENDPOINT = 'users'
export const SIGNUP_ENDPOINT_NAME = 'SIGNUP'


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

export const apiLogin = (options) => ({
  [CALL_API]: {
    types: apiEvents(LOGIN_ENDPOINT_NAME),
    endpoint: LOGIN_ENDPOINT,
    name: LOGIN_ENDPOINT_NAME,
    options: {...options, method: 'post'}
  }
})

export const apiSignup = (options) => ({
  [CALL_API]: {
    types: apiEvents(SIGNUP_ENDPOINT_NAME),
    endpoint: SIGNUP_ENDPOINT,
    name: SIGNUP_ENDPOINT_NAME,
    options: {...options, method: 'post'}
  }
})
