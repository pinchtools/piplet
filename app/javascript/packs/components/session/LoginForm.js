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
import {LOGIN_FORM} from './../../actions/LoginDialog'

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
      <FormGroup
        controlId="formUsername"
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
