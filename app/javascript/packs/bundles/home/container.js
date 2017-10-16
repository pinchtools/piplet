import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { addEditor } from './../comment_editor/actions'
import HomeComp from  './component'
import * as actions from './actions'
import * as userActions from './../user/actions'
import { LOGIN_ENDPOINT } from './../login/actions'
import { DEFAULT_RESPONSE, doesTokenExpired, isUnableToProcess } from './../../lib/http'

class Home extends Component {
  static propTypes = {
    userResponse: PropTypes.object.isRequired,
    loginResponse: PropTypes.object.isRequired,
    userState: PropTypes.object.isRequired,
    createDefaultEditor: PropTypes.func.isRequired,
    getUser: PropTypes.func.isRequired,
    updateToken: PropTypes.func.isRequired
  }

  connected = false
  tokenPingInterval = 1000 * 60 * 10

  constructor(props) {
    super(props)
    props.createDefaultEditor(0)
    if (this.tokensPresent())
      this.props.getUser()
    setInterval(this.updateToken.bind(this), this.tokenPingInterval)
  }

  componentWillReceiveProps(nextProps) {
    this.receiveUserResponse(nextProps)
    this.receiveTokenResponse(nextProps)

    this.connected = nextProps.userState.logged && this.tokensPresent()
  }

  render() {
    return (
      <HomeComp connected={this.connected}/>
    )
  }

  receiveUserResponse(nextProps) {
    let response = this.props.userResponse
    let nextResponse = nextProps.userResponse
    let error

    if (!nextResponse || response.meta.timestamp == nextResponse.meta.timestamp)
      return
    if ((error = nextResponse.meta.error) && !response.meta.error) {
      if (doesTokenExpired(error)) {
        this.updateToken()
      } else {
        localStorage.clear()
        this.props.loginFailed()
      }
    } else if (nextResponse.meta.success && !response.meta.success) {
      this.props.loginSucceed()
    }
  }

  receiveTokenResponse(nextProps) {
    let response = this.props.tokenResponse
    let nextResponse = nextProps.tokenResponse
    let error

    if (!nextResponse || response.meta.timestamp == nextResponse.meta.timestamp)
      return
    if ((error = nextResponse.meta.error) && !response.meta.error) {
      if (isUnableToProcess(error)) {
        localStorage.clear()
        this.props.loginFailed()
      }
    }
  }

  updateToken() {
    let refreshToken = localStorage.getItem('refreshToken')
    if (refreshToken) {
      this.props.updateToken({ data: { refresh_token: refreshToken } })
    }
  }

  tokensPresent() {
    return localStorage.getItem('csrfToken') != null && localStorage.getItem('refreshToken') != null
  }
}

const mapStateToProps = (state) => {
  return {
    loginResponse: state.api[LOGIN_ENDPOINT] || DEFAULT_RESPONSE,
    userResponse: state.api[actions.GET_USER_ENDPOINT] || DEFAULT_RESPONSE,
    userState: state.user
  }
}

const mapDispatchToProps = dispatch => {
  return {
    createDefaultEditor: (id) => {
      dispatch(addEditor(id))
    },
    getUser:() => {
      dispatch(actions.getUser())
    },
    updateToken:(options) => {
      dispatch(actions.updateToken(options))
    },
    loginSucceed:() => {
      dispatch(userActions.loginSucceed())
    },
    loginFailed:() => {
      dispatch(userActions.loginFailed())
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Home)
