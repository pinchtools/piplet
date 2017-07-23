import { connect } from 'react-redux'
import { toggleDialog } from './../../actions/LoginDialog'
import HeaderComp from  './../../components/home/Header'

const mapStateToProps = () => { return {} }

const mapDispatchToProps = dispatch => {
  return {
    onLoginToggle: () => {
      dispatch(toggleDialog())
    }
  }
}

const Header = connect(
  mapStateToProps,
  mapDispatchToProps
)(HeaderComp)

export default Header
