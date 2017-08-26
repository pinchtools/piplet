import React from 'react'
import PropTypes from 'prop-types'
import {FormattedMessage} from 'react-intl'
import Form from 'react-bootstrap/lib/Form'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import Row from 'react-bootstrap/lib/Row'
import Col from 'react-bootstrap/lib/Col'
import Button from 'react-bootstrap/lib/Button'
import Alert from 'react-bootstrap/lib/Alert'
import {LOGIN_FORM} from './../actions'

const LoginForm = ({ form }) => {
  let emailClass = form == LOGIN_FORM ? 'hidden' : ''

  return (
    <Form>
      <Row>
        <Col sm={12} className="text-center hidden-xs">
          <Button bsStyle="primary">
            <i className="fa fa-facebook" aria-hidden="true"></i>
            <FormattedMessage id="LoginDialog.auth.fb" defaultMessage={`Facebook`} />
          </Button>
          <Button bsStyle="primary">
            <i className="fa fa-google" aria-hidden="true"></i>
            <FormattedMessage id="LoginDialog.auth.google" defaultMessage={`Google`} />
          </Button>
          <Button bsStyle="primary">
            <i className="fa fa-twitter" aria-hidden="true"></i>
            <FormattedMessage id="LoginDialog.auth.twitter" defaultMessage={`Twitter`} />
          </Button>
        </Col>
        <Col xs={12} className="text-center visible-xs">
          <Button bsStyle="primary" bsSize="small" block>
            <i className="fa fa-facebook" aria-hidden="true"></i>
            <FormattedMessage id="LoginDialog.auth.fb" defaultMessage={`Facebook`} />
          </Button>
          <Button bsStyle="primary" bsSize="small" block>
            <i className="fa fa-google" aria-hidden="true"></i>
            <FormattedMessage id="LoginDialog.auth.google" defaultMessage={`Google`} />
          </Button>
          <Button bsStyle="primary" bsSize="small" block>
            <i className="fa fa-twitter" aria-hidden="true"></i>
            <FormattedMessage id="LoginDialog.auth.twitter" defaultMessage={`Twitter`} />
          </Button>
        </Col>
      </Row>
      <br/>

      <Alert bsStyle="danger">
        <h4>Oh snap! You got an error!</h4>
        <ul>
          <li>jkjkj</li>
          <li>jqsqsqkjkj</li>
        </ul>
        <p>sdqdq</p>
        <p>Change this and that and try again. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Cras mattis consectetur purus sit amet fermentum.</p>
      </Alert>

      <FormGroup
        controlId="formUsername"
        validationState="error"
      >
        <ControlLabel>
          <FormattedMessage
            id="LoginDialog.username"
            defaultMessage={`username`}
          />
        </ControlLabel>
        <FormControl
          type="text"
        />
        <FormControl.Feedback />
      </FormGroup>
      <FormGroup
        controlId="formEmail"
        className={emailClass}
      >
        <ControlLabel>
          <FormattedMessage
            id="LoginDialog.email"
            defaultMessage={`email`}
          />
        </ControlLabel>
        <FormControl
          type="email"
        />
        <FormControl.Feedback />
      </FormGroup>
      <FormGroup
        controlId="formPassword"
      >
        <ControlLabel>
          <FormattedMessage
            id="LoginDialog.password"
            defaultMessage={`password`}
          />
        </ControlLabel>
        <FormControl
          type="password"
        />
        <FormControl.Feedback />
      </FormGroup>
    </Form>
  )
}

LoginForm.propTypes = {
  form: PropTypes.string.isRequired
}

export default LoginForm
