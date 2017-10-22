import React from 'react'
import {FormattedMessage} from 'react-intl'
import Row from 'react-bootstrap/lib/Row'
import Col from 'react-bootstrap/lib/Col'
import Button from 'react-bootstrap/lib/Button'
import PropTypes from 'prop-types'

const Oauth = (props) => {
  return (
    <Row className={`${props.providers.length == 0 ? 'hidden' : 'show'}`}>
      <Col sm={12} className="text-center hidden-xs">
        <Button bsStyle="primary" className={`${props.providers.indexOf('facebook') != -1 ? '' : 'hidden'}`} onClick={() => props.oauthenticate('facebook')}>
          <i className="fa fa-facebook" aria-hidden="true"></i>
          <FormattedMessage id="LoginDialog.auth.fb" defaultMessage={`Facebook`} />
        </Button>
        <Button bsStyle="primary" className={`${props.providers.indexOf('google') != -1 ? '' : 'hidden'}`} onClick={() => props.oauthenticate('google')}>
          <i className="fa fa-google" aria-hidden="true"></i>
          <FormattedMessage id="LoginDialog.auth.google" defaultMessage={`Google`} />
        </Button>
        <Button bsStyle="primary" className={`${props.providers.indexOf('twitter') != -1 ? '' : 'hidden'}`} onClick={() => props.oauthenticate('twitter')}>
          <i className="fa fa-twitter" aria-hidden="true"></i>
          <FormattedMessage id="LoginDialog.auth.twitter" defaultMessage={`Twitter`} />
        </Button>
      </Col>
      <Col xs={12} className="text-center visible-xs">
        <Button bsStyle="primary" bsSize="small" block className={`${props.providers.indexOf('facebook') != -1 ? '' : 'hidden'}`} onClick={() => props.oauthenticate('facebook')}>
          <i className="fa fa-facebook" aria-hidden="true"></i>
          <FormattedMessage id="LoginDialog.auth.fb" defaultMessage={`Facebook`} />
        </Button>
        <Button bsStyle="primary" bsSize="small" block className={`${props.providers.indexOf('google') != -1 ? '' : 'hidden'}`} onClick={() => props.oauthenticate('google')}>
          <i className="fa fa-google" aria-hidden="true"></i>
          <FormattedMessage id="LoginDialog.auth.google" defaultMessage={`Google`} />
        </Button>
        <Button bsStyle="primary" bsSize="small" block className={`${props.providers.indexOf('twitter') != -1 ? '' : 'hidden'}`} onClick={() => props.oauthenticate('twitter')}>
          <i className="fa fa-twitter" aria-hidden="true"></i>
          <FormattedMessage id="LoginDialog.auth.twitter" defaultMessage={`Twitter`} />
        </Button>
      </Col>
    </Row>
  )
}

Oauth.propTypes = {
  providers: PropTypes.arrayOf(PropTypes.string).isRequired,
  oauthenticate: PropTypes.func.isRequired
}

export default Oauth
