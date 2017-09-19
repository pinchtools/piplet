import { combineReducers } from 'redux'
import loginDialog from './loginDialog'
import comments from './comments'
import editors from './editors'
import api from './api'
import user from './user'

const appReducer = combineReducers({
  loginDialog,
  comments,
  editors,
  api,
  user
})

export default appReducer
