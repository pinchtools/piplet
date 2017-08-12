import React from 'react'
import Grid from 'react-bootstrap/lib/Grid'
import Row from 'react-bootstrap/lib/Row'
import Col from 'react-bootstrap/lib/Col'
import ThreadLevel from './ThreadLevel'
import Comment from './Comment'

const Thread = () => {
  return (
    <Grid className="thread">
      <Row>
        <Col xs={12}>
          <ThreadLevel classes="level-1">
            <Comment>
              <ThreadLevel classes="level-2">
                <Comment>
                  <ThreadLevel classes="level-3">
                    <Comment/>
                    <Comment/>
                  </ThreadLevel>
                </Comment>
                <Comment/>
              </ThreadLevel>
            </Comment>
            <Comment>
              <ThreadLevel classes="level-2">
                <Comment/>
                <Comment/>
              </ThreadLevel>
            </Comment>
            <Comment/>
            <Comment/>
            <Comment/>
          </ThreadLevel>
        </Col>
      </Row>
    </Grid>
  )
}

export default Thread
