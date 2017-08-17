import { connect } from 'react-redux'
import { toggleDialog, selectLogin, selectSignup } from './actions'
import LoginDialogComp from  './component'

const mapStateToProps = (state) => {
  return {
    loginProps: state.loginDialog
  }
}

const mapDispatchToProps = dispatch => {
  return {
    onLoginToggle: () => {
      dispatch(toggleDialog())
    },
    onSelectLogin: () => {
      dispatch(selectLogin())
    },
    onSelectSignup: () => {
      dispatch(selectSignup())
    }
  }
}

const LoginDialog = connect(
  mapStateToProps,
  mapDispatchToProps
)(LoginDialogComp)

export default LoginDialog
