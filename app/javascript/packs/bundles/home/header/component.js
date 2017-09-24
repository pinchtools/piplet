import React from 'react'
import PropTypes from 'prop-types'
import {FormattedMessage} from 'react-intl'
import Navbar from 'react-bootstrap/lib/Navbar'
import Nav from 'react-bootstrap/lib/Nav'
import NavItem from 'react-bootstrap/lib/NavItem'

const Header = (props) => {
  console.log('HHHHH')
  let rightNav = null
  if (props.connected) {
    rightNav = null
  } else {
    rightNav = <NavItem eventKey={1} onClick={() => props.onLoginToggle()} href="#">
      <FormattedMessage
        id="Header.login"
        defaultMessage={`login`}
      />
    </NavItem>
  }



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
            {rightNav}
          </Nav>
        </Navbar.Collapse>
      </Navbar>
    </div>
  )
}


Header.propTypes = {
  onLoginToggle: PropTypes.func.isRequired,
  connected: PropTypes.bool.isRequired
}

export default Header
