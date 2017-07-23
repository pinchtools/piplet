import {TOGGLE_LOGIN, DEFAULT_VISIBILITY} from './../actions/LoginDialog'

function loginDialog(state = {}, action) {
  switch (action.type) {
    case TOGGLE_LOGIN:
      return Object.assign({}, state, { open: !state.open })
    default:
      return { open: DEFAULT_VISIBILITY }
  }
}

export default loginDialog
