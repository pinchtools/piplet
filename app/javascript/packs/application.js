/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import React from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'
import { createStore, applyMiddleware } from 'redux'
import thunk from 'redux-thunk'
import appReducer from './reducers'
import App from './components/App'
import Intl from './components/Intl'
import api from './middlewares/api'

const middleware = [ thunk, api ]

const store = createStore(
  appReducer,
  applyMiddleware(...middleware)
)

ReactDOM.render(
  <Provider store={store}>
    <Intl>
      <App />
    </Intl>
  </Provider>,
  document.getElementById('root')
)
