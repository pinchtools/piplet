import React from 'react'
import PropTypes from 'prop-types'
import {FormattedMessage} from 'react-intl'
import Modal from 'react-bootstrap/lib/Modal'
import Form from 'react-bootstrap/lib/Form'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import Button from 'react-bootstrap/lib/Button'


const LoginDialog = ({ loginProps, onLoginToggle }) => {
  return (
    <Modal show={loginProps.open} onHide={() => onLoginToggle()}>
      <Modal.Header closeButton>
        <Modal.Title>
          <FormattedMessage
            id="LoginDialog.title"
            defaultMessage={`Login`}
          />
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form>
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
      </Modal.Body>
      <Modal.Footer>
        <Button onClick={() => onLoginToggle()}>
          <FormattedMessage
            id="LoginDialog.cancel"
            defaultMessage={`cancel`}
          />
        </Button>
        <Button bsStyle="primary" onClick={() => onLoginToggle()}>
          <FormattedMessage
            id="LoginDialog.submit"
            defaultMessage={`submit`}
          />
        </Button>
      </Modal.Footer>
    </Modal>
  )
}

LoginDialog.propTypes = {
  loginProps: PropTypes.shape({
    open: PropTypes.bool.isRequired
  }).isRequired,
  onLoginToggle: PropTypes.func.isRequired
}

export default LoginDialog
