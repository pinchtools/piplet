import React from 'react'
import PropTypes from 'prop-types'
import {FormattedMessage, defineMessages, injectIntl, intlShape } from 'react-intl'
import {Editor, EditorState} from 'draft-js'
import Grid from 'react-bootstrap/lib/Grid'
import Row from 'react-bootstrap/lib/Row'
import Col from 'react-bootstrap/lib/Col'

class CommentEditor extends React.Component {
  constructor(props) {
    super(props);
    this.editorState = props.editorProps.editorState;
    // this.onChange = (editorState) => {
    //   props.onChange(editorState);
    // }

    this.state = {editorState: EditorState.createEmpty()};
    this.onChange = (editorState) => this.setState({editorState});


    this.onFocus = () => props.onFocus();
  }
  render() {
    return (
      <Grid>
        <Row>
          <Col xs={12}>
            <div className="comment">
              <div className="panel panel-default">
                <div className="panel-body">
                  <Editor
                    editorState={this.state.editorState}
                    onChange={this.onChange}
                    onFocus={this.onFocus}
                    placeholder="Write a comment ..."
                  />
                </div>
              </div>
            </div>
          </Col>
        </Row>
      </Grid>
    )
  }
}


CommentEditor.propTypes = {
  editorProps: PropTypes.shape({
    focus: PropTypes.bool.isRequired,
    editorState: PropTypes.object.isRequired,
  }).isRequired,
  onFocus: PropTypes.func.isRequired
}

export default CommentEditor
