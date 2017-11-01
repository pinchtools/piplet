import {REQUEST, SUCCESS, FAILURE, API_DELETE} from './../middlewares/api'

function api(state = {}, action) {
  if (!action.endpoint) return state

  if (action.type.endsWith(REQUEST)) {
    return Object.assign({}, state, {
      [action.name]:
        {meta: {loading: true, error: null, success: false, timestamp: Date.now()}}
    })
  } else if (action.type.endsWith(FAILURE)) {
    return Object.assign({}, state, {
      [action.name]: {
        meta: {loading: false, error: action.error, success: false, timestamp: Date.now()}
      }
    })
  } else if (action.type.endsWith(SUCCESS)) {
    return Object.assign({}, state, {
      [action.name]: {
        ...action.response,
        meta: {loading: false, error: null, success: true, timestamp: Date.now()}
      }
    })
  } else if (action.type == API_DELETE) {
    let {[action.name]: omit, ...newState} = state
    return newState
  }
  return state
}

export default api
