import React, { Component } from 'react'
import Header from './header/container'
import LoginDialog from './../login/container'
import CommentEditor from './../comment_editor/container'
import Thread from './../thread/container'
import Grid from 'react-bootstrap/lib/Grid'
import Row from 'react-bootstrap/lib/Row'
import Col from 'react-bootstrap/lib/Col'

class Index extends Component {
  constructor (props) {
    super(props);
    props.createDefaultEditor(0)
  }

  render() {
    return (
      <div>
        <Header/>
        <LoginDialog/>
        <Grid>
          <Row>
            <Col xs={12}>
              <CommentEditor id={0}/>
            </Col>
          </Row>
        </Grid>
        <Thread/>
      </div>
    )
  }
}

export default Index
