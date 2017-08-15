import {REPLY_COMMENT} from './../actions/Comment'
import { COMMENTS_RECEIVE } from './../bundles/thread/actions'

function comments(state = {}, action) {
  switch (action.type) {
    case COMMENTS_RECEIVE:
      return {
        ...state,
        ...action.list
      }
    case REPLY_COMMENT:
      return {
        ...state,
        [action.id]: {
          ...state[action.id],
          _reply: !state[action.id]['_reply']
        }
      }
    default:
      return state
  }
}

export default comments
