import React, { Component } from 'react'
import Header from './../../containers/home/Header'
import LoginDialog from './../../containers/session/LoginDialog'

class Index extends Component {
  componentDidMount() {
  }

  render() {
    return (
      <div>
        <Header/>
        <LoginDialog/>
        Index page
      </div>
    )
  }
}

export default Index
