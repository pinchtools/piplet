import React, { Component } from 'react'
import PropTypes from 'prop-types'
import {FormattedMessage, defineMessages, injectIntl, intlShape } from 'react-intl'
import Modal from 'react-bootstrap/lib/Modal'
import Button from 'react-bootstrap/lib/Button'
import Tabs from 'react-bootstrap/lib/Tabs'
import Tab from 'react-bootstrap/lib/Tab'
import LoginForm from './login_form/container'
import SignupForm from './signup_form/container'
import {LOGIN_FORM, SIGNUP_FORM} from './actions'
// import moment from 'moment'
import moment from 'moment-timezone'

class LoginDialog extends Component {
  static propTypes = {
    loginState: PropTypes.shape({
      open: PropTypes.bool.isRequired,
      form: PropTypes.string.isRequired
    }).isRequired,
    loginResponse: PropTypes.object.isRequired,
    signupResponse: PropTypes.object.isRequired,
    onLoginToggle: PropTypes.func.isRequired,
    onSelectLogin: PropTypes.func.isRequired,
    onSelectSignup: PropTypes.func.isRequired,
    onRequestLogin: PropTypes.func.isRequired,
    onRequestSignup: PropTypes.func.isRequired,
    getProviders: PropTypes.func.isRequired,
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
    this.signup = this.signup.bind(this)
    props.getProviders()
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
    this.props.onRequestSignup({
      data: {
        email: this.state.email,
        password: this.state.password,
        password_confirmation: this.state.password,
        username: this.state.username,
        time_zone: moment.tz.guess()
      }
    })
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
    let signupLoading = this.props.signupResponse.meta.loading
    return (
      <Modal id="login-modal" show={loginState.open} onHide={onLoginToggle}>
        <Modal.Body >
          <Tabs id="login-tabs" defaultActiveKey={2} onSelect={(key) => this.handleSelect(key)}>
            <Tab id="signup-tab" eventKey={1} title={intl.formatMessage(this.constructor.messages.tabSignupTitle)}>
              <SignupForm handleChange={this.handleFormChange}/>
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
          <Button
            bsStyle="primary"
            className={signupButtonClass}
            disabled={signupLoading}
            onClick={!signupLoading ? this.signup : null}
          >
            <FormattedMessage
              id="LoginDialog.submit.signup"
              defaultMessage={`signup`}
            />
            {signupLoading ? '...' : ''}
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
