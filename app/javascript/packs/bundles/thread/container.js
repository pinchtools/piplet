import { connect } from 'react-redux'
import ThreadComp from  './component'


const mapStateToProps = (state) => {
  return {
    comments: state.comments
  }
}

export default connect(
  mapStateToProps
)(ThreadComp)
