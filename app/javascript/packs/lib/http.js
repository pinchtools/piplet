export const DEFAULT_RESPONSE = { meta: { loading: false, error: null } }

export const doesRequestSucceed = (response) => {
 return response.status && response.status.toString().indexOf(2) == 0
}
