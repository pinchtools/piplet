import normalize from 'json-api-normalizer'
import axios from 'axios'

const API_ROOT = 'http://localhost:3000/api/v1/'

function callApi(endpoint, options = {}) {
  options['url'] = (endpoint.indexOf(API_ROOT) === -1) ? API_ROOT + endpoint : endpoint

  axios.interceptors.response.use(function (response) {
    console.log('intercept ok')
    return Object.assign({}, normalize(response.data, { endpoint }))
  }, function (error) {
    let payload = {data: null, status: null, message: null}
    if (error.response) {
      payload = {
        data: error.response.data,
        status: error.response.status,
        message: error.response.statusText,
      }
    }
    else {
      payload['message'] = error.message || 'Unexpected error'
    }
    console.log(payload)
    return Promise.reject(payload)
  });

  return axios(options)
}

// Action key that carries API call info interpreted by this Redux middleware.
export const CALL_API = 'Call API'

// A Redux middleware that interprets actions with CALL_API info specified.
// Performs the call and promises when such actions are dispatched.
export default store => next => action => {
  const callAPI = action[CALL_API]
  if (typeof callAPI === 'undefined') {
    return next(action)
  }

  let { endpoint } = callAPI
  const { options, types } = callAPI

  if (typeof endpoint === 'function') {
    endpoint = endpoint(store.getState())
  }

  if (typeof endpoint !== 'string') {
    throw new Error('Specify a string endpoint URL.')
  }
  if (!Array.isArray(types) || types.length !== 3) {
    throw new Error('Expected an array of three action types.')
  }
  if (!types.every(type => typeof type === 'string')) {
    throw new Error('Expected action types to be strings.')
  }

  const actionWith = data => {
    const finalAction = Object.assign({}, action, data)
    delete finalAction[CALL_API]
    return finalAction
  }

  const [ requestType, successType, failureType ] = types
  next(actionWith({ type: requestType, endpoint }))

  return callApi(endpoint, options)
    .then(response => next(actionWith({
        type: successType,
        response,
        endpoint
      }))
    )
    .catch(error => next(actionWith({
        type: failureType,
        error,
        endpoint
      }))
    )
}
