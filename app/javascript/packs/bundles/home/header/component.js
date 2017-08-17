import React from 'react'
import PropTypes from 'prop-types'
import {FormattedMessage} from 'react-intl'
import Navbar from 'react-bootstrap/lib/Navbar'
import Nav from 'react-bootstrap/lib/Nav'
import NavItem from 'react-bootstrap/lib/NavItem'

const Header = ({ onLoginToggle }) => {
  return (
    <div>
      <Navbar collapseOnSelect>
        <Navbar.Header>
          <Navbar.Brand>
              84 comments
          </Navbar.Brand>
          <Navbar.Toggle />
        </Navbar.Header>
        <Navbar.Collapse>
          <Nav pullRight>
            <NavItem eventKey={1} onClick={() => onLoginToggle()} href="#">
              <FormattedMessage
                id="Header.login"
                defaultMessage={`login`}
              />
            </NavItem>
          </Nav>
        </Navbar.Collapse>
      </Navbar>
    </div>
  )
}


Header.propTypes = {
  onLoginToggle: PropTypes.func.isRequired
}

export default Header
