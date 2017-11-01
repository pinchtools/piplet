import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Header from './header/container'
import LoginDialog from './../login/container'
import CommentEditor from './../comment_editor/container'
import Thread from './../thread/container'
import Grid from 'react-bootstrap/lib/Grid'
import Row from 'react-bootstrap/lib/Row'
import Col from 'react-bootstrap/lib/Col'

class Index extends Component {
  constructor (props) {
    super(props)
  }

  render() {
    let content
    if (this.props.connected) {
      content = <div>
        <Grid>
          <Row>
            <Col xs={12}>
              <CommentEditor id={0}/>
            </Col>
          </Row>
        </Grid>
        <Thread/>
      </div>
    } else {
      content = <div>
        <LoginDialog/>
      </div>
    }

    return (
      <div>
        <Header connected={this.props.connected}/>
        {content}
      </div>
    )
  }
}

Index.propTypes = {
  connected: PropTypes.bool.isRequired
}

export default Index
