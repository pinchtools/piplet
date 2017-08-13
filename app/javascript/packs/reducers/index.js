import { combineReducers } from 'redux'
import loginDialog from './loginDialog'
import commentEditor from './commentEditor'

const appReducer = combineReducers({
  loginDialog,
  commentEditor
})

export default appReducer
