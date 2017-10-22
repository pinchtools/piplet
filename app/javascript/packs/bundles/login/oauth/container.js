import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import object from 'lodash/object'
import * as actions from './actions'
import OauthComp from  './component'
import { DEFAULT_RESPONSE } from './../../../lib/http'


class Oauth extends Component {
  static propTypes = {
    providersResponse: PropTypes.object.isRequired
  }
  static defaultProps = {
    providersResponse: DEFAULT_RESPONSE
  }

  providers = []

  constructor(props) {
    super(props)
    this.updateProviders()
  }

  componentDidUpdate(prevProps, prevState) {
    this.updateProviders()
  }

  updateProviders() {
    let response = this.props.providersResponse
    let data
    if (response && (data = response.data)) {
      this.providers = object.keys(data.oauthProviders)
    }
  }

  oauthenticate(provider) {
    window.open("/auth/" + provider + '?from=client')
  }

  render() {
    return (
      <OauthComp providers={this.providers} oauthenticate={this.oauthenticate}/>
    )
  }
}

const mapStateToProps = (state) => {
  return {
    providersResponse: state.api[actions.OAUTH_PROVIDERS_ENDPOINT_NAME]
  }
}


const mapDispatchToProps = dispatch => {
  return {
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Oauth)
