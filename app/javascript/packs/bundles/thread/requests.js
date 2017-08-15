import * as actions from './actions'

export const fetchComments = () => dispatch => {
  dispatch(actions.requestComments())
  let comments = {
    1: { id: 1, level: 1, parent: 0},
    2: { id: 2, level: 2, parent: 1},
    3: { id: 3, level: 3, parent: 2},
    4: { id: 4, level: 3, parent: 2},
    5: { id: 5, level: 2, parent: 1},
    6: { id: 6, level: 1, parent: 0},
    7: { id: 7, level: 2, parent: 6},
    8: { id: 8, level: 2, parent: 6},
    9: { id: 9, level: 1, parent: 0},
    10: { id: 10, level: 1, parent: 0},
    11: { id: 11, level: 1, parent: 0}
  }
  dispatch(actions.receiveComments(comments))
}


// const fetchPosts = reddit => dispatch => {
//   dispatch(requestPosts(reddit))
//   return fetch(`https://www.reddit.com/r/${reddit}.json`)
//     .then(response => response.json())
//     .then(json => dispatch(receivePosts(reddit, json)))
// }
