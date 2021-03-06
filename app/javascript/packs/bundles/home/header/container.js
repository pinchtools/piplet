import { connect } from 'react-redux'
import { toggleDialog } from './../../login/actions'
import * as userActions from './../../user/actions'
import HeaderComp from  './component'

const mapStateToProps = () => { return {} }

const mapDispatchToProps = dispatch => {
  return {
    onLoginToggle: () => {
      dispatch(toggleDialog())
    },
    onLogout: () => {
      localStorage.clear()
      dispatch(userActions.logout())
    }
  }
}

const Header = connect(
  mapStateToProps,
  mapDispatchToProps
)(HeaderComp)

export default Header
