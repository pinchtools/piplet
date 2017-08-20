import { combineReducers } from 'redux'
import loginDialog from './loginDialog'
import comments from './comments'
import editors from './editors'

const appReducer = combineReducers({
  loginDialog,
  comments,
  editors
})

export default appReducer
