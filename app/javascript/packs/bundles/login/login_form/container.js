import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import * as actions from './../actions'
import LoginFormComp from  './component'
import { DEFAULT_RESPONSE } from './../../../lib/http'


class LoginForm extends Component {
  static propTypes = {
    handleChange: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props)
  }

  componentDidUpdate(prevProps, prevState) {
    /// TODO get the reponse via middleware/api does not seem to 'normalize' correctly
    // {"data":{"id":"1","type":"users","attributes":{"email":"example@piplet.io","username":"Example","api-access-token":"XXX","api-refresh-token":"XXX"}}}
    // if (this.props.response.data)
    console.log(this.props.response)
  }

  render() {
    return (
      <LoginFormComp {...this.props}/>
    )
  }
}

const mapStateToProps = (state) => {
  return {
    response: state.api[actions.LOGIN_ENDPOINT] || DEFAULT_RESPONSE
  }
}

const mapDispatchToProps = dispatch => {
  return {
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(LoginForm)
