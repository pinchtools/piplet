import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Grid from 'react-bootstrap/lib/Grid'
import Row from 'react-bootstrap/lib/Row'
import Col from 'react-bootstrap/lib/Col'
import ThreadLevel from './../../components/ThreadLevel'
import Comment from './../../containers/Comment'
import * as req from './requests'

class Thread extends Component {
  static propTypes = {
    comments: PropTypes.object.isRequired,
    dispatch: PropTypes.func.isRequired
  }

  componentDidMount() {
    const { dispatch } = this.props
    dispatch(req.fetchComments())
  }

  componentWillReceiveProps(nextProps) {
    // if (nextProps.selectedReddit !== this.props.selectedReddit) {
    //   const { dispatch, selectedReddit } = nextProps
    //   dispatch(fetchPostsIfNeeded(selectedReddit))
    // }
  }

  renderComments(parent, level) {
    let comments = Object.values(this.props.comments)
    let selection = comments.filter(function(co) { return co.parent == parent && co.level == level })
    let comps = []

    if (selection.length == 0) return

    for(var co of selection) {
      comps.push(
        <Comment key={`comment-${co.id}`} id={co.id}>
          {this.renderComments(co.id, level+1)}
        </Comment>
      )
    }

    return (
      <ThreadLevel classes={`level-${level}`}>
        {comps}
      </ThreadLevel>
    )
  }

  render() {
    let tree = this.renderComments(0, 1)

    return (
      <Grid className="thread">
        <Row>
          <Col xs={12}>
            {tree}
          </Col>
        </Row>
      </Grid>
    )
  }
}

export default Thread
