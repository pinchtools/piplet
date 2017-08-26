import { combineReducers } from 'redux'
import loginDialog from './loginDialog'
import comments from './comments'
import editors from './editors'
import api from './api'

const appReducer = combineReducers({
  loginDialog,
  comments,
  editors,
  api
})

export default appReducer
