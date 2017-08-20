import { connect } from 'react-redux'
import { addEditor } from './../comment_editor/actions'
import HomeComp from  './component'


const mapStateToProps = (state, props) => {
  return {}
}

const mapDispatchToProps = dispatch => {
  return {
    createDefaultEditor: (id) => {
      dispatch(addEditor(id))
    }
  }
}

const Home = connect(
  mapStateToProps,
  mapDispatchToProps
)(HomeComp)

export default Home
