import React from 'react'
import { BrowserRouter as Router, Route } from 'react-router-dom'

import Index from './containers/home/Index.js'

export default () => {
  return (
    <Router basename="/client">
      <div>
        <Route exact path="/" component={ Index } />
      </div>
    </Router>
  )
}
