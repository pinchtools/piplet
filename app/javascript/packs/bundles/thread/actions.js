export const COMMENTS_REQUEST = 'COMMENTS_REQUEST'
export const COMMENTS_RECEIVE = 'COMMENTS_RECEIVE'

export const requestComments = () => {
  return {
    type: COMMENTS_REQUEST
  }
}

export const receiveComments = (list) => {
  return {
    type: COMMENTS_RECEIVE,
    list
  }
}

