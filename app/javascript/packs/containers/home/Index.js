import React, { Component } from 'react'
import Header from './../../containers/home/Header'
import LoginDialog from './../../containers/session/LoginDialog'
import Thread from './../../components/Thread'

class Index extends Component {
  componentDidMount() {
  }

  render() {
    return (
      <div>
        <Header/>
        <LoginDialog/>
        <Thread/>
      </div>
    )
  }
}

export default Index
