import React from 'react'
import PropTypes from 'prop-types'
import {FormattedMessage, defineMessages, injectIntl, intlShape } from 'react-intl'
import Modal from 'react-bootstrap/lib/Modal'
import Button from 'react-bootstrap/lib/Button'
import Tabs from 'react-bootstrap/lib/Tabs'
import Tab from 'react-bootstrap/lib/Tab'
import LoginForm from './LoginForm'
import {LOGIN_FORM, SIGNUP_FORM} from './../../actions/LoginDialog'

const messages = defineMessages({
  tabSignupTitle: {
    id: "LoginDialog.Tab.Signup.Title",
    defaultMessage: "Signup",
  },
  tabLoginTitle: {
    id: "LoginDialog.Tab.Login.Title",
    defaultMessage: "Login",
  },

});


const LoginDialog = ({ loginProps, onLoginToggle, onSelectLogin, onSelectSignup, intl }) => {
  let handleSelect = (key) => {
    if (key == 1) onSelectSignup()
    else onSelectLogin()
  }

  let signupButtonClass = loginProps.form == LOGIN_FORM ? 'hidden' : ''
  let loginButtonClass = loginProps.form == SIGNUP_FORM ? 'hidden' : ''

  return (
    <Modal id="login-modal" show={loginProps.open} onHide={() => onLoginToggle()}>
      <Modal.Body >
        <Tabs defaultActiveKey={2} onSelect={handleSelect}>
          <Tab eventKey={1} title={intl.formatMessage(messages.tabSignupTitle)}>
            <LoginForm form={SIGNUP_FORM}/>
          </Tab>
          <Tab eventKey={2} title={intl.formatMessage(messages.tabLoginTitle)}>
            <LoginForm form={LOGIN_FORM}/>
          </Tab>
        </Tabs>
      </Modal.Body>
      <Modal.Footer>
        <Button onClick={() => onLoginToggle()}>
          <FormattedMessage
            id="LoginDialog.cancel"
            defaultMessage={`cancel`}
          />
        </Button>
        <Button bsStyle="primary" className={signupButtonClass} onClick={() => onLoginToggle()}>
          <FormattedMessage
            id="LoginDialog.submit.signup"
            defaultMessage={`signup`}
          />
        </Button>
        <Button bsStyle="primary" className={loginButtonClass} onClick={() => onLoginToggle()}>
          <FormattedMessage
            id="LoginDialog.submit.login"
            defaultMessage={`login`}
          />
        </Button>
      </Modal.Footer>
    </Modal>
  )
}

LoginDialog.propTypes = {
  loginProps: PropTypes.shape({
    open: PropTypes.bool.isRequired,
    form: PropTypes.string.isRequired
  }).isRequired,
  onLoginToggle: PropTypes.func.isRequired,
  onSelectLogin: PropTypes.func.isRequired,
  onSelectSignup: PropTypes.func.isRequired,
  intl: intlShape.isRequired
}

export default injectIntl(LoginDialog)
