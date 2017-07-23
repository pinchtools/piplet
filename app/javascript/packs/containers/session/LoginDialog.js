import { connect } from 'react-redux'
import { toggleDialog } from './../../actions/LoginDialog'
import LoginDialogComp from  './../../components/session/LoginDialog'

const mapStateToProps = (state) => {
  return {
    loginProps: state.loginDialog
  }
}

const mapDispatchToProps = dispatch => {
  return {
    onLoginToggle: () => {
      dispatch(toggleDialog())
    }
  }
}

const LoginDialog = connect(
  mapStateToProps,
  mapDispatchToProps
)(LoginDialogComp)

export default LoginDialog
