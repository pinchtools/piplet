import { connect } from 'react-redux'
import { toggleDialog } from './../../login/actions'
import HeaderComp from  './component'

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
