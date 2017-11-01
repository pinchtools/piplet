import React from 'react'
import { BrowserRouter as Router, Route } from 'react-router-dom'

import Index from './bundles/home/container'

export default () => {
  return (
    <Router basename="/client">
      <div>
        <Route exact path="/" component={ Index } />
      </div>
    </Router>
  )
}
