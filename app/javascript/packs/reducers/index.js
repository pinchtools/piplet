import { combineReducers } from 'redux'
import loginDialog from './loginDialog'
import comments from './comments'
import commentEditor from './commentEditor'

const appReducer = combineReducers({
  loginDialog,
  comments,
  commentEditor
})

export default appReducer
