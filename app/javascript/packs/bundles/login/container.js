import { connect } from 'react-redux'
import * as actions from './actions'
import * as providersActions from './oauth/actions'
import LoginDialogComp from  './component'
import { DEFAULT_RESPONSE } from './../../lib/http'

const mapStateToProps = (state) => {
  return {
    loginState: state.loginDialog,
    loginResponse: state.api[actions.LOGIN_ENDPOINT_NAME] || DEFAULT_RESPONSE
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
    onRequestLogin: (options) => {
      dispatch(actions.apiLogin(options))
    },
    getProviders:() => {
      dispatch(providersActions.getProviders())
    }
  }
}

const LoginDialog = connect(
  mapStateToProps,
  mapDispatchToProps
)(LoginDialogComp)

export default LoginDialog
