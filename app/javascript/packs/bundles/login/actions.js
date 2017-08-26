import { CALL_API } from './../../middlewares/api'

export const TOGGLE_LOGIN = 'TOGGLE_LOGIN'
export const SELECT_LOGIN = 'SELECT_LOGIN'
export const SELECT_SIGNUP = 'SELECT_SIGNUP'

export const LOGIN_FORM = 'login'
export const SIGNUP_FORM = 'signup'
export const DEFAULT_VISIBILITY = false

export const LOGIN_ENDPOINT = 'tokens'

export const [LOGIN_REQUEST, LOGIN_SUCCESS, LOGIN_FAILURE] = ['LOGIN_REQUEST', 'LOGIN_SUCCESS', 'LOGIN_FAILURE']

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
    types: [ LOGIN_REQUEST, LOGIN_SUCCESS, LOGIN_FAILURE ],
    endpoint: LOGIN_ENDPOINT,
    options: {...options, method: 'post'}
  }
})
