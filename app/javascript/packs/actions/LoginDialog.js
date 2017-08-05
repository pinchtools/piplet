export const TOGGLE_LOGIN = 'TOGGLE_LOGIN'
export const SELECT_LOGIN = 'SELECT_LOGIN'
export const SELECT_SIGNUP = 'SELECT_SIGNUP'

export const LOGIN_FORM = 'login'
export const SIGNUP_FORM = 'signup'
export const DEFAULT_VISIBILITY = false

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