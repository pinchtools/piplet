import * as actions from './../bundles/user/actions'

function user(state = {}, action) {
  switch (action.type) {
    case actions.USER_LOGIN_SUCCEED:
      return {
        ...state,
        logged: true
      }
    case actions.USER_LOGOUT:
    case actions.USER_LOGIN_FAILED:
      return {...state, logged: false}
    default:
      return Object.assign({}, {logged: false}, state)
  }
}

export default user
