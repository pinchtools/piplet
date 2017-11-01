export const DEFAULT_RESPONSE = { meta: { loading: false, error: null, success: false, timestamp: null } }

export const doesRequestSucceed = (response) => {
 return response.status && response.status.toString().indexOf(2) == 0
}

export const responseCode = (response) => {
  return response.data.meta.code
}

export const doesTokenExpired = (response) => {
  return responseCode(response) == RESPONSE_CODES['expired_token']
}

export const isUnableToProcess = (response) => {
  return responseCode(response) == RESPONSE_CODES['unprocessable_entity']
}

export const RESPONSE_CODES = {
  ok: 0,
  no_content: 0,
  created: 1,
  accepted: 2,
  unprocessable_entity: 100,
  not_found: 101,
  invalid_token: 102,
  expired_token: 103,
  expired_refresh_token: 104
}
