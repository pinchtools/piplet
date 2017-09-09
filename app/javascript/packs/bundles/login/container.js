import { connect } from 'react-redux'
import * as actions from './actions'
import LoginDialogComp from  './component'
import { DEFAULT_RESPONSE } from './../../lib/http'

const mapStateToProps = (state) => {
  return {
    loginState: state.loginDialog,
    loginResponse: state.api[actions.LOGIN_ENDPOINT] || DEFAULT_RESPONSE
  }
}

const mapDispatchToProps = dispatch => {
  return {
    onLoginToggle: () => {
      dispatch(actions.toggleDialog())
    },
    onSelectLogin: () => {
      dispatch(actions.selectLogin())
    },
    onSelectSignup: () => {
      dispatch(actions.selectSignup())
    },
    onRequestSignup: (options) => {
    },
    onSuccessSignup: () => {
    },
    onErrorSignup: () => {
    },
    onRequestLogin: (options) => {
      dispatch(actions.apiLogin(options))
    },
    onSuccessLogin: () => {
    },
    onErrorLogin: () => {
    },
  }
}

const LoginDialog = connect(
  mapStateToProps,
  mapDispatchToProps
)(LoginDialogComp)

export default LoginDialog
