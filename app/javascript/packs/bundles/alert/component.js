import React from 'react'
import PropTypes from 'prop-types'
import Alert from 'react-bootstrap/lib/Alert'

const AlertComp = ({ visibility, style, title, list, paragraphs }) => {
  title = (title) ? <h4>{title}</h4> : ''

  if (list && list.length) {
    list = <ul>
      {list.map(function(item, i) {
        return <li key={`alert-li-${i}`}>{item}</li>
      })}
    </ul>
  }

  if (paragraphs && paragraphs.length) {
    paragraphs = <div>
      {paragraphs.map(function(item, i) { return <p key={`alert-p-${i}`}>{item}</p> })}
    </div>
  }

  return (
    <Alert bsStyle={style || "danger"} className={`${visibility ? 'show' : 'hidden'}`}>
      {title}
      {paragraphs}
      {list}
    </Alert>
  )
}

AlertComp.propTypes = {
  visibility: PropTypes.bool,
  style: PropTypes.string,
  title: PropTypes.string,
  list: PropTypes.arrayOf(PropTypes.string),
  paragraphs: PropTypes.arrayOf(PropTypes.string)
}

export default AlertComp
