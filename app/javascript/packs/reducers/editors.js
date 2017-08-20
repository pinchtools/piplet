import {EDITOR_FOCUS, EDITOR_ADD, EDITOR_TOGGLE, EDITOR_PUBLISH} from './../bundles/comment_editor/actions'

function createEditor(id) {
  return {
    id,
    focus: (id) ? true : false,
    visibility: (id) ? false : true,
    content: {}
  }
}


function editors(state = {}, action) {
  switch (action.type) {
    case EDITOR_ADD:
      return {
        ...state,
        [action.id]: createEditor(action.id)
      }
    case EDITOR_TOGGLE:
      return {
        ...state,
        [action.id]: {
          ...state[action.id],
          visibility: !state[action.id].visibility
        }
      }
    case EDITOR_FOCUS:
      return {
        ...state,
        [action.id]: {
          ...state[action.id],
          focus: true
        }
      }
    case EDITOR_PUBLISH:
      return {
        ...state,
        [action.id]: {
          ...state[action.id],
          content: action.content
        }
      }
    default:
      return state
  }
}
export default editors
