import React from 'react'
import PropTypes from 'prop-types'

const ThreadLevel = (props) => {
  return (
    <div className={`thread-level ` + props.classes}>
      {props.children}
    </div>
  )
}

ThreadLevel.propTypes = {
  classes: PropTypes.string.isRequired,
}

export default ThreadLevel
