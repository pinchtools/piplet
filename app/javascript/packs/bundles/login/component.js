import React, { Component } from 'react'
import PropTypes from 'prop-types'
import {FormattedMessage, defineMessages, injectIntl, intlShape } from 'react-intl'
import Modal from 'react-bootstrap/lib/Modal'
import Button from 'react-bootstrap/lib/Button'
import Tabs from 'react-bootstrap/lib/Tabs'
import Tab from 'react-bootstrap/lib/Tab'
import LoginForm from './form/component'
import {LOGIN_FORM, SIGNUP_FORM} from './actions'

class LoginDialog extends Component {
  static propTypes = {
    loginState: PropTypes.shape({
      open: PropTypes.bool.isRequired,
      form: PropTypes.string.isRequired
    }).isRequired,
    loginData: PropTypes.object.isRequired,
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
    this.login = this.login.bind(this)
  }

  componentDidUpdate(prevProps, prevState) {
    console.log(this.props.loginData)
  }

  handleSelect(key) {
    if (key == 1) this.props.onSelectSignup()
    else this.props.onSelectLogin()
  }

  login() {
    this.props.onRequestLogin({
      data: {
        username: 'reer',
        password: 'rerere'
      }
    })
  }

  signup() {

  }

  render() {
    let {loginState, onLoginToggle, intl} = this.props
    let signupButtonClass = loginState.form == LOGIN_FORM ? 'hidden' : ''
    let loginButtonClass = loginState.form == SIGNUP_FORM ? 'hidden' : ''
    let signupLoading = this.props.loginData.meta.loading
    return (
      <Modal id="login-modal" show={loginState.open} onHide={onLoginToggle}>
        <Modal.Body >
          <Tabs id="login-tabs" defaultActiveKey={2} onSelect={(key) => this.handleSelect(key)}>
            <Tab id="signup-tab"  eventKey={1} title={intl.formatMessage(this.constructor.messages.tabSignupTitle)}>
              <LoginForm form={SIGNUP_FORM} data={this.props.loginData}/>
            </Tab>
            <Tab id="login-tab" eventKey={2} title={intl.formatMessage(this.constructor.messages.tabLoginTitle)}>
              <LoginForm form={LOGIN_FORM} data={this.props.loginData}/>
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
            disabled={signupLoading}
            onClick={!signupLoading ? this.login : null}
          >
            <FormattedMessage
              id="LoginDialog.submit.login"
              defaultMessage={`login`}
            />
            {signupLoading ? '...' : ''}
          </Button>
        </Modal.Footer>
      </Modal>
    )
  }
}

export default injectIntl(LoginDialog)
