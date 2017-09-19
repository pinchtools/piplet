export const USER_LOGIN_SUCCEED = 'USER_LOGIN_SUCCEED'
export const USER_LOGIN_FAILED = 'USER_LOGIN_FAILED'
export const USER_ACCESS_TOKEN_EXPIRED = 'USER_ACCESS_TOKEN_EXPIRED'
export const USER_REFRESH_TOKEN_EXPIRED = 'USER_REFRESH_TOKEN_EXPIRED'

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

export const accessTokenExpired = () => {
  return {
    type: USER_ACCESS_TOKEN_EXPIRED
  }
}

export const refreshTokenExpired = () => {
  return {
    type: USER_REFRESH_TOKEN_EXPIRED
  }
}
