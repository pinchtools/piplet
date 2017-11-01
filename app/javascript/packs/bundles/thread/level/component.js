import React from 'react'
import PropTypes from 'prop-types'

const Level = (props) => {
  return (
    <div className={`thread-level ` + props.classes}>
      {props.children}
    </div>
  )
}

Level.propTypes = {
  classes: PropTypes.string.isRequired,
}

export default Level
