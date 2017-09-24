import normalize from 'json-api-normalizer'
import axios from 'axios'

const API_ROOT = 'http://localhost:3000/api/v1/'
const EVENTS = ['REQUEST', 'SUCCESS', 'FAILURE']
export const [REQUEST, SUCCESS, FAILURE] = EVENTS
export const API_DELETE = 'API_DELETE'

const httpClient = axios.create({
  baseURL: API_ROOT
})

httpClient.interceptors.response.use(function (response) {
  return Object.assign({}, {...response, data: normalize(response.data)})
}, function (error) {
  let o = {data: null, status: null, message: null}
  if (error.response) {
    o = {
      data: error.response.data,
      status: error.response.status,
      message: error.response.statusText,
    }
  } else {
    o['message'] = error.message || 'Unexpected error'
  }
  return Promise.reject(o)
});

function callApi(endpoint, options = {}) {
  options['url'] = endpoint
  options['headers'] = options['headers'] || {}
  let token
  if (token = localStorage.getItem('apiAccessToken')) {
    options['headers']['Authorisation'] = token
  }

  return httpClient(options)
}

export const apiEvents = (endpointName) => {
  return EVENTS.map((e) => {return endpointName + '_' + e})
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

  const [ requestType, successType, failureType ] = types
  const actionWith = data => {
    const finalAction = Object.assign({}, action, data)
    delete finalAction[CALL_API]
    return finalAction
  }

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
