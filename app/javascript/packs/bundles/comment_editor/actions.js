export const EDITOR_ADD = 'EDITOR_ADD'
export const EDITOR_TOGGLE = 'EDITOR_TOGGLE'
export const EDITOR_FOCUS = 'EDITOR_FOCUS'
export const EDITOR_PUBLISH = 'EDITOR_PUBLISH'


export const addEditor = (id) => {
  return {
    type: EDITOR_ADD,
    id
  }
}

export const toggleEditor = (id) => {
  return {
    type: EDITOR_TOGGLE,
    id
  }
}

export const focusEditor = (id) => {
  return {
    type: EDITOR_FOCUS,
    id
  }
}

export const publishEditor = (id, content) => {
  return {
    type: EDITOR_FOCUS,
    id,
    content
  }
}
