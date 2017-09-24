import { CALL_API, apiEvents } from './../../middlewares/api'

export const GET_USER_ENDPOINT_NAME = 'GET_USER'
export const GET_USER_ENDPOINT = 'users/show'

export const getUser = (options) => ({
  [CALL_API]: {
    types: apiEvents(GET_USER_ENDPOINT_NAME),
    endpoint: GET_USER_ENDPOINT,
    options: {...options, method: 'get'}
  }
})


export const deleteUser = () => {
  return {
    type: 'API_DELETE',
    endpoint: GET_USER_ENDPOINT,
  }
}

