import { CALL_API, apiEvents } from './../../middlewares/api'

export const GET_USER_ENDPOINT_NAME = 'GET_USER'
export const GET_USER_ENDPOINT = 'users/show'

export const UPDATE_TOKEN_ENDPOINT_NAME = 'UPDATE_TOKEN'
export const UPDATE_TOKEN_ENDPOINT = 'tokens'

export const getUser = (options) => ({
  [CALL_API]: {
    types: apiEvents(GET_USER_ENDPOINT_NAME),
    endpoint: GET_USER_ENDPOINT,
    name: GET_USER_ENDPOINT_NAME,
    options: {...options, method: 'get'}
  }
})

export const updateToken = (options) => ({
  [CALL_API]: {
    types: apiEvents(UPDATE_TOKEN_ENDPOINT_NAME),
    endpoint: UPDATE_TOKEN_ENDPOINT,
    name: UPDATE_TOKEN_ENDPOINT_NAME,
    options: {...options, method: 'put'}
  }
})
