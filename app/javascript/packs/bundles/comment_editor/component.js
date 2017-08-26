import React from 'react'
import PropTypes from 'prop-types'
import {FormattedMessage, defineMessages, injectIntl, intlShape } from 'react-intl'
import {Editor, EditorState, convertToRaw} from 'draft-js'
import Button from 'react-bootstrap/lib/Button'


class CommentEditor extends React.Component {
  constructor(props) {
    super(props);
    this.id = props.id || 0;
    // this.editorState = props.editor.editorState;
    this.state = {editorState: EditorState.createEmpty()};
    this.onChange = (editorState) => this.setState({editorState});
    this.setDomEditorRef = ref => this.domEditor = ref;

    this.messages = defineMessages({
      placeholder: {
        id: "CommentEditor.placeholder",
        defaultMessage: "Write a comment ...",
      },
    });
  }

  componentDidUpdate() {
    if (this.props.editor.visibility && this.id) {
      this.domEditor.focus();
    }
  }

  onFocus() {
    this.props.onFocus(this.props.id);
  }

  onPublish() {
    let content = this.state.editorState.getCurrentContent();

    // /!\ is it really usaful to save in in redux
    // server side save should be sufficient
    this.props.onFocus(this.props.id, convertToRaw(content));
  }

  render() {
    return (
        <div className={`comment-editor ${this.props.editor.visibility ? 'show' : 'hidden'}`}>
          <div className="panel panel-default">
            <div className="panel-body">
              <Editor
                editorState={this.state.editorState}
                onChange={this.onChange}
                onFocus={() => this.onFocus()}
                placeholder={this.props.intl.formatMessage(this.messages.placeholder)}
                ref={this.setDomEditorRef}
              />
            </div>
            <div className={`panel-footer text-right ${this.props.editor.focus ? 'show' : 'hidden'}`}>
              <Button bsStyle="primary" bsSize="small" onClick={() => this.onPublish()}>
                <FormattedMessage
                  id="CommentEditor.publish"
                  defaultMessage={`publish`}
                />
              </Button>
            </div>
          </div>
        </div>
    )
  }
}

CommentEditor.propTypes = {
  editor: PropTypes.shape({
    focus: PropTypes.bool.isRequired,
    visibility: PropTypes.bool.isRequired,
    content: PropTypes.object.isRequired
  }).isRequired,
  onFocus: PropTypes.func.isRequired,
  intl: intlShape.isRequired,
}

export default injectIntl(CommentEditor)
