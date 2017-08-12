import React from 'react'
import avatar from './../images/avatar.jpg'
import Button from 'react-bootstrap/lib/Button'
import ButtonToolbar from 'react-bootstrap/lib/ButtonToolbar'
import DropdownButton from 'react-bootstrap/lib/DropdownButton'
import MenuItem from 'react-bootstrap/lib/MenuItem'

const Comment = (props) => {
  return (
    <div className="comment">
      <div className="panel panel-default">
        <div className="panel-heading">
          <div className="pull-left">
            <img className="avatar" src={avatar}/>
          </div>
          <div className="pull-right">
            <Button bsSize="small" bsStyle='link'><i className="fa fa-link" aria-hidden="true"></i></Button>
            <Button bsSize="small" bsStyle='link'><i className="fa fa-heart-o" aria-hidden="true"></i></Button>
          </div>
          <div>
            <div className="username"><a href="#">Pinchtools</a></div>
            <div className="date">5 minutes ago</div>
          </div>
        </div>
        <div className="panel-body">
          That camera looks pretty terrible, way to hype up nothing.
        </div>
        <div className="panel-footer">
          <div className="pull-right secondary-actions">
            <ButtonToolbar>
              <Button bsSize="small" bsStyle='link'><small>reply</small></Button>
              <DropdownButton bsSize="small" bsStyle='link' pullRight id='dropdown-more-actions'>
                <MenuItem eventKey="1">Block user</MenuItem>
                <MenuItem eventKey="2">Flag as innapropriate</MenuItem>
              </DropdownButton>
            </ButtonToolbar>
          </div>
          <div className="primary-actions">
            <i className="highlight fa fa-bullhorn" aria-hidden="true"></i>

            <Button bsStyle='link'><i className="fa fa-graduation-cap" aria-hidden="true"></i></Button>
            <Button bsStyle='link'><i className="fa fa-bullhorn" aria-hidden="true"></i></Button>
            <Button bsStyle='link'><i className="fa fa-thumbs-o-up" aria-hidden="true"></i></Button>
            <Button bsStyle='link'><i className="fa fa-lightbulb-o" aria-hidden="true"></i></Button>
          </div>
        </div>
      </div>
      {props.children}
    </div>
  )
}

export default Comment
