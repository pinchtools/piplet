import * as actions from './../bundles/user/actions'

function user(state = {}, action) {
  switch (action.type) {
    case actions.USER_LOGIN_SUCCEED:
      return {
        ...state,
        logged: true,
        access_token_expired: false,
        refresh_token_expired: false
      }
    case actions.USER_LOGIN_FAILED:
      return {...state, logged: true}
    case actions.USER_ACCESS_TOKEN_EXPIRED:
      return {...state, access_token_expired: true}
    case actions.USER_REFRESH_TOKEN_EXPIRED:
      return {...state, refresh_token_expired: true}
    default:
      return Object.assign({}, {logged: false, access_token_expired: false, refresh_token_expired: false}, state)
  }
}

export default user
