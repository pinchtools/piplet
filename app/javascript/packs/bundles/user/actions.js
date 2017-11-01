export const USER_LOGIN_SUCCEED = 'USER_LOGIN_SUCCEED'
export const USER_LOGIN_FAILED = 'USER_LOGIN_FAILED'
export const USER_LOGOUT = 'USER_LOGOUT'
export const USER_SIGNUP_SUCCEED = 'USER_SIGNUP_SUCCEED'

export const loginSucceed = () => {
  return {
    type: USER_LOGIN_SUCCEED
  }
}

export const loginFailed = () => {
  return {
    type: USER_LOGIN_FAILED
  }
}

export const logout = () => {
  return {
    type: USER_LOGOUT
  }
}

export const signupSucceed = () => {
  return {
    type: USER_SIGNUP_SUCCEED
  }
}
