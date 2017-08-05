import {TOGGLE_LOGIN, SELECT_LOGIN, SELECT_SIGNUP, DEFAULT_VISIBILITY, LOGIN_FORM, SIGNUP_FORM} from './../actions/LoginDialog'

function loginDialog(state = {}, action) {
  switch (action.type) {
    case TOGGLE_LOGIN:
      return Object.assign({}, state, { open: !state.open })
    case SELECT_LOGIN:
      return Object.assign({}, state, { form: LOGIN_FORM })
    case SELECT_SIGNUP:
      return Object.assign({}, state, { form: SIGNUP_FORM })
    default:
      return { open: DEFAULT_VISIBILITY, form: LOGIN_FORM }
  }
}

export default loginDialog
