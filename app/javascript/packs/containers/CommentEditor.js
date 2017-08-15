import { connect } from 'react-redux'
import { focusEditor } from './../actions/CommentEditor'
import CommentEditorComp from  './../components/CommentEditor'

const mapStateToProps = (state) => {
  return {
    editorProps: state.commentEditor
  }
}

const mapDispatchToProps = dispatch => {
  return {
    onFocus: () => {
      dispatch(focusEditor())
    },
    onChange: (editorState) => {
      dispatch(changeEditor(editorState))
    }
  }
}

const CommentEditor = connect(
  mapStateToProps,
  mapDispatchToProps
)(CommentEditorComp)

export default CommentEditor
