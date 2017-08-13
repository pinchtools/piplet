import React, { Component } from 'react'
import Header from './Header'
import LoginDialog from './../session/LoginDialog'
import CommentEditor from './../../containers/CommentEditor'
import Thread from './../../components/Thread'

class Index extends Component {
  componentDidMount() {
  }

  render() {
    return (
      <div>
        <Header/>
        <LoginDialog/>
        <CommentEditor/>
        <Thread/>
      </div>
    )
  }
}

export default Index
