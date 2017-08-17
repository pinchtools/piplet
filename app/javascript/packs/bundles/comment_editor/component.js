import React from 'react'
import PropTypes from 'prop-types'
import {FormattedMessage, defineMessages, injectIntl, intlShape } from 'react-intl'
import {Editor, EditorState} from 'draft-js'
import Grid from 'react-bootstrap/lib/Grid'
import Row from 'react-bootstrap/lib/Row'
import Col from 'react-bootstrap/lib/Col'
import Button from 'react-bootstrap/lib/Button'


class CommentEditor extends React.Component {
  constructor(props) {
    super(props);
    this.editorState = props.editorProps.editorState;
    this.state = {editorState: EditorState.createEmpty()};
    this.onChange = (editorState) => this.setState({editorState});

    this.onFocus = () => props.onFocus();

    this.messages = defineMessages({
      placeholder: {
        id: "CommentEditor.placeholder",
        defaultMessage: "Write a comment ...",
      },
    });
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
                    placeholder={this.props.intl.formatMessage(this.messages.placeholder)}
                  />
                </div>
                <div className={`panel-footer text-right ${this.props.editorProps.focus ? 'show' : 'hidden'}`}>
                  <Button bsStyle="primary" bsSize="small">
                    <FormattedMessage
                      id="CommentEditor.publish"
                      defaultMessage={`publish`}
                    />
                  </Button>
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
    focus: PropTypes.bool.isRequired
  }).isRequired,
  onFocus: PropTypes.func.isRequired,
  intl: intlShape.isRequired
}

export default injectIntl(CommentEditor)
