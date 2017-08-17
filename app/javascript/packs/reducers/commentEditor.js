import {FOCUS_EDITOR, CHANGE_EDITOR, DEFAULT_FOCUS} from './../bundles/comment_editor/actions'
import {EditorState} from 'draft-js'

function commentEditor(state = {}, action) {
  switch (action.type) {
    case FOCUS_EDITOR:
      return Object.assign({}, state, { focus: true })
    default:
      return { focus: DEFAULT_FOCUS, editorState: EditorState.createEmpty() }
  }
}

export default commentEditor
