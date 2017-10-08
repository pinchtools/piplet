import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { addEditor } from './../comment_editor/actions'
import HomeComp from  './component'
import * as actions from './actions'
import * as userActions from './../user/actions'
import { LOGIN_ENDPOINT } from './../login/actions'
import { DEFAULT_RESPONSE, doesTokenExpired } from './../../lib/http'

class Home extends Component {
  static propTypes = {
    userResponse: PropTypes.object.isRequired,
    loginResponse: PropTypes.object.isRequired,
    userState: PropTypes.object.isRequired,
    createDefaultEditor: PropTypes.func.isRequired,
    getUser: PropTypes.func.isRequired
  }

  connected = false

  constructor(props) {
    super(props)
    props.createDefaultEditor(0)
    if (this.tokenExists()) {
      this.props.getUser()
    }
  }

  componentWillReceiveProps(nextProps) {
    let userResponse = this.props.userResponse
    let nextUserResponse = nextProps.userResponse
    let error
    if ((error = nextUserResponse.meta.error) && !userResponse.meta.error) {
      if (doesTokenExpired(error)) {
        console.log('expired')

        //// TODO ask for new token before
        /// and when the refresh token expired to ask for a new one
      } else {
        console.log('failed')
        // localStorage.removeItem('apiAccessToken')
        this.props.loginFailed()
      }
    } else if (nextUserResponse.meta.success && !userResponse.meta.success) {
      this.props.loginSucceed()
    }

    if (this.props.userState.logged && this.tokenExists()) {
      this.connected = true
    }
  }

  render() {
    return (
      <HomeComp connected={this.connected}/>
    )
  }

  tokenExists() {
    return localStorage.getItem('apiAccessToken') != null
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
    loginSucceed:() => {
      dispatch(userActions.loginSucceed())
    },
    loginFailed:() => {
      dispatch(userActions.loginFailed())
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Home)
