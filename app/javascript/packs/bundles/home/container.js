import React, { Component } from 'react'
import Header from './header/container'
import LoginDialog from './../login/container'
import CommentEditor from './../comment_editor/container'
import Thread from './../thread/container'

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
