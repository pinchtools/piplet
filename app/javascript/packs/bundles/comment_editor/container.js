import { connect } from 'react-redux'
import { focusEditor, publishEditor } from './actions'
import CommentEditorComp from  './component'


const mapStateToProps = (state, props) => {
  return {
    editor: state.editors[props.id]
  }
}

const mapDispatchToProps = dispatch => {
  return {
    onFocus: (id) => {
      dispatch(focusEditor(id))
    },
    onPublish: (id, content) => {
      dispatch(publishEditor(id, content))
    }
    // onChange: (editorState) => {
    //   dispatch(changeEditor(editorState))
    // }
  }
}

const CommentEditor = connect(
  mapStateToProps,
  mapDispatchToProps
)(CommentEditorComp)

export default CommentEditor
