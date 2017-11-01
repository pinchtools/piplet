import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import object from 'lodash/object'
import * as actions from './../actions'
import * as userActions from './../../user/actions'
import SignupFormComp from  './component'
import { DEFAULT_RESPONSE } from './../../../lib/http'


class SignupForm extends Component {
  static propTypes = {
    handleChange: PropTypes.func.isRequired,
    dispatch: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props)
  }

  componentDidUpdate(prevProps, prevState) {
    let response = this.props.response
    let data
    if (response && (data = response.data)) {
      let user = object.values(data.users)[0]
      let attrs = user.attributes
      if (attrs['csrfToken']) {
        localStorage.setItem('csrfToken', attrs['csrfToken'])
      }
      if (attrs['refreshToken']) {
        localStorage.setItem('refreshToken', attrs['refreshToken'])
      }

      this.props.dispatch(actions.toggleDialog())
      this.props.dispatch(userActions.signupSucceed())
    }
  }

  render() {
    return (
      <SignupFormComp {...this.props}/>
    )
  }
}

const mapStateToProps = (state) => {
  return {
    response: state.api[actions.SIGNUP_ENDPOINT_NAME] || DEFAULT_RESPONSE
  }
}

export default connect(mapStateToProps)(SignupForm)
