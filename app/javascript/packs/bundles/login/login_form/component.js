import React, { Component } from 'react'
import PropTypes from 'prop-types'
import {FormattedMessage} from 'react-intl'
import Form from 'react-bootstrap/lib/Form'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import Alert from './../../alert/component'
import Oauth from './../oauth/component'

class LoginForm extends Component {
  static propTypes = {
    response: PropTypes.object.isRequired,
    handleChange: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props)
    this.handleChange = props.handleChange.bind(this)
  }

  render() {
    let error = this.props.response.meta.error
    let alertVisible = !!error
    let errors = (alertVisible) ? error.data.errors.map((e) => e.detail) : []

    return (
      <Form>
        <Oauth />
        <br/>

        <Alert
          visibility={alertVisible}
          list={errors}
        />

        <FormGroup
          controlId="formEmail"
        >
          <ControlLabel>
            <FormattedMessage
              id="LoginForm.email"
              defaultMessage={`email`}
            />
          </ControlLabel>
          <FormControl
            type="email"
            name="email"
            onChange={this.handleChange}
          />
          <FormControl.Feedback />
        </FormGroup>
        <FormGroup
          controlId="formPassword"
        >
          <ControlLabel>
            <FormattedMessage
              id="LoginForm.password"
              defaultMessage={`password`}
            />
          </ControlLabel>
          <FormControl
            type="password"
            name="password"
            onChange={this.handleChange}
          />
          <FormControl.Feedback />
        </FormGroup>
      </Form>
    )
  }
}

export default LoginForm
