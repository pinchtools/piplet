import React, { Component } from 'react'
import PropTypes from 'prop-types'
import {FormattedMessage} from 'react-intl'
import Form from 'react-bootstrap/lib/Form'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import HelpBlock from 'react-bootstrap/lib/HelpBlock'
import Alert from './../../alert/component'
import Oauth from './../oauth/container'
import ValidationErrors from './../../../lib/validationErrors'

class SignupForm extends Component {
  static propTypes = {
    response: PropTypes.object.isRequired,
    handleChange: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props)
    this.handleChange = this.props.handleChange.bind(this)
  }

  render() {
    let validationErrors = new ValidationErrors(this.props.response.meta.error)
    return (
      <Form>
        <Oauth />
        <br/>
        <Alert
          visibility={!validationErrors.empty()}
          list={validationErrors.messages()}
        />

        <FormGroup
          controlId="formUsername"
          validationState={(validationErrors.contains('username')) ? "error" : null}
        >
          <ControlLabel>
            <FormattedMessage
              id="SignupForm.username"
              defaultMessage={`username`}
            />
          </ControlLabel>
          <FormControl
            name="username"
            type="text"
            onChange={this.handleChange}
          />
          <FormControl.Feedback />
          <HelpBlock>Help text with validation state.</HelpBlock>
        </FormGroup>
        <FormGroup
          controlId="formEmail"
          validationState={(validationErrors.contains('email')) ? "error" : null}
        >
          <ControlLabel>
            <FormattedMessage
              id="SignupForm.email"
              defaultMessage={`email`}
            />
          </ControlLabel>
          <FormControl
            name="email"
            type="email"
            onChange={this.handleChange}
          />
          <FormControl.Feedback />
        </FormGroup>
        <FormGroup
          controlId="formPassword"
          validationState={(validationErrors.contains('password')) ? "error" : null}
        >
          <ControlLabel>
            <FormattedMessage
              id="SignupForm.password"
              defaultMessage={`password`}
            />
          </ControlLabel>
          <FormControl
            name="password"
            type="password"
            onChange={this.handleChange}
          />
          <FormControl.Feedback />
        </FormGroup>
      </Form>
    )
  }
}

export default SignupForm
