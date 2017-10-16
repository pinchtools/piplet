import React, { Component } from 'react'
import PropTypes from 'prop-types'
import {FormattedMessage, defineMessages, injectIntl, intlShape } from 'react-intl'
import Modal from 'react-bootstrap/lib/Modal'
import Button from 'react-bootstrap/lib/Button'
import Tabs from 'react-bootstrap/lib/Tabs'
import Tab from 'react-bootstrap/lib/Tab'
import LoginForm from './login_form/container'
import SignupForm from './signup_form/component'
import {LOGIN_FORM, SIGNUP_FORM} from './actions'

class LoginDialog extends Component {
  static propTypes = {
    loginState: PropTypes.shape({
      open: PropTypes.bool.isRequired,
      form: PropTypes.string.isRequired
    }).isRequired,
    loginResponse: PropTypes.object.isRequired,
    onLoginToggle: PropTypes.func.isRequired,
    onSelectLogin: PropTypes.func.isRequired,
    onSelectSignup: PropTypes.func.isRequired,
    onRequestLogin: PropTypes.func.isRequired,
    intl: intlShape.isRequired,
  }

  static messages = defineMessages({
    tabSignupTitle: {
      id: "LoginDialog.Tab.Signup.Title",
      defaultMessage: "Signup",
    },
    tabLoginTitle: {
      id: "LoginDialog.Tab.Login.Title",
      defaultMessage: "Login",
    }
  })

  constructor(props) {
    super(props)
    this.state = {
      email: null,
      password: null,
      username: null
    }
    this.login = this.login.bind(this)
  }

  handleSelect(key) {
    if (key == 1) this.props.onSelectSignup()
    else this.props.onSelectLogin()
  }

  login(event) {
    // event.preventDefault();
    this.props.onRequestLogin({
      data: {
        email: this.state.email,
        password: this.state.password
      }
    })
  }

  signup() {
  }

  handleFormChange = (event) => {
    const target = event.target
    const value = target.type === 'checkbox' ? target.checked : target.value
    const name = target.name

    this.setState({ [name]: value })
  }

  render() {
    let {loginState, onLoginToggle, intl} = this.props
    let signupButtonClass = loginState.form == LOGIN_FORM ? 'hidden' : ''
    let loginButtonClass = loginState.form == SIGNUP_FORM ? 'hidden' : ''
    let loginLoading = this.props.loginResponse.meta.loading
    return (
      <Modal id="login-modal" show={loginState.open} onHide={onLoginToggle}>
        <Modal.Body >
          <Tabs id="login-tabs" defaultActiveKey={2} onSelect={(key) => this.handleSelect(key)}>
            <Tab id="signup-tab" eventKey={1} title={intl.formatMessage(this.constructor.messages.tabSignupTitle)}>
              <SignupForm response={this.props.loginResponse} handleChange={this.handleFormChange}/>
            </Tab>
            <Tab id="login-tab" eventKey={2} title={intl.formatMessage(this.constructor.messages.tabLoginTitle)}>
              <LoginForm handleChange={this.handleFormChange}/>
            </Tab>
          </Tabs>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={onLoginToggle}>
            <FormattedMessage
              id="LoginDialog.cancel"
              defaultMessage={`cancel`}
            />
          </Button>
          <Button bsStyle="primary" className={signupButtonClass} onClick={() => this.signup()}>
            <FormattedMessage
              id="LoginDialog.submit.signup"
              defaultMessage={`signup`}
            />
          </Button>
          <Button
            bsStyle="primary"
            className={loginButtonClass}
            disabled={loginLoading}
            onClick={!loginLoading ? this.login : null}
          >
            <FormattedMessage
              id="LoginDialog.submit.login"
              defaultMessage={`login`}
            />
            {loginLoading ? '...' : ''}
          </Button>
        </Modal.Footer>
      </Modal>
    )
  }
}

export default injectIntl(LoginDialog)
