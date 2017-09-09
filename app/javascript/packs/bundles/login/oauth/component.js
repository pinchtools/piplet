import React from 'react'
import {FormattedMessage} from 'react-intl'
import Row from 'react-bootstrap/lib/Row'
import Col from 'react-bootstrap/lib/Col'
import Button from 'react-bootstrap/lib/Button'

const Oauth = () => {
  return (
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
  )
}

export default Oauth
