import * as actions from './../bundles/login/actions'

function loginDialog(state = {}, action) {
  switch (action.type) {
    case actions.TOGGLE_LOGIN:
      return Object.assign({}, state, { open: !state.open })
    case actions.SELECT_LOGIN:
      return Object.assign({}, state, { form: actions.LOGIN_FORM })
    case actions.SELECT_SIGNUP:
      return Object.assign({}, state, { form: actions.SIGNUP_FORM })
    case actions.LOGIN_REQUEST:
      return Object.assign({}, state, { loading: true })
    case actions.LOGIN_FAILURE:
      return Object.assign({}, state, { loading: false, errors: action.errors })

    default:
      return Object.assign({}, { open: actions.DEFAULT_VISIBILITY, form: actions.LOGIN_FORM }, state)
  }
}

export default loginDialog
