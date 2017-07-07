const user = (state = [], action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return [
        ...state,
      ]
    default:
      return state
  }
}

export default user
