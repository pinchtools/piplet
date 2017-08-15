export const REPLY_COMMENT = 'REPLY_COMMENT'

export const replyComment = (id) => {
  return {
    type: REPLY_COMMENT,
    id
  }
}
