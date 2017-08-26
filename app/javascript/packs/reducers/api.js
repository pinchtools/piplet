const [REQUEST, SUCCESS, FAILURE] = ['REQUEST', 'SUCCESS', 'FAILURE']

function api(state = {}, action) {
  if (action.type.endsWith(REQUEST)) {
    return Object.assign({}, state, {
      [action.endpoint]:
        {meta: {loading: true, error: null}}
    })
  } else if (action.type.endsWith(FAILURE)) {
    console.log('failed')
    return Object.assign({}, state, {
      [action.endpoint]: {
        ...state[action.endpoint],
        meta: {loading: false, error: action.error}
      }
    })
  } else if (action.type.endsWith(SUCCESS)) {
    return Object.assign({}, state, {
      [action.endpoint]: {
        response: action.response,
        meta: {loading: false, error: null}
      }
    })
  }
  return state
}

export default api
