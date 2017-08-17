import React from 'react'
import PropTypes from 'prop-types'
import avatar from './../../images/avatar.jpg'
import Button from 'react-bootstrap/lib/Button'
import ButtonToolbar from 'react-bootstrap/lib/ButtonToolbar'
import DropdownButton from 'react-bootstrap/lib/DropdownButton'
import MenuItem from 'react-bootstrap/lib/MenuItem'
import CommentEditor from './../comment_editor/container'

const Comment = (props) => {
  let editor = (props.comment._reply) ? <CommentEditor /> : '';
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
          I own both the S8+ and the oneplus 5. Agree pretty much with most of the review.
          {/*I own both the S8+ and the oneplus 5. Agree pretty much with most of the review. I think there was too much hype on the camera, however, the camera isn't bad. The phone takes decent pictures...some good, some not so...I have the same issue with the S8+. Android Authority did a blind photo comparison...Oneplus 5 came in second...goes to show how close these phones are...*/}
          {/*Now, actually using the phone day to day, I think the software experience on the 5 is excellent. I use the phone on T-Mobile. Call quality is excellent and sounds better than the Samsung...I think it maybe just that the speaker doesn't sit right when using the S8+ for me, but the 1+ just is a better call experience...and I use my phone as a phone a lot...*/}
          {/*I also am not a big fan of the curved screen on the S8, but will say that the actual quality of the display on that phone has no equal...just plain sharp...*/}
          {/*I would probably use the S8+ as my daily driver if the finger print reader wasn't so bad...*/}
        </div>
        <div className="panel-footer">
          <div className="pull-right secondary-actions">
            <ButtonToolbar>
              <Button bsSize="small" bsStyle='link' onClick={() => props.onReply(props.comment.id)}><small>reply</small></Button>
              <DropdownButton bsSize="small" bsStyle='link' pullRight id='dropdown-more-actions' title="">
                <MenuItem eventKey="1">Block user</MenuItem>
                <MenuItem eventKey="2">Flag as inappropriate</MenuItem>
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
      {editor}
      {props.children}
    </div>
  )
}

Comment.propTypes = {
  comment: PropTypes.object.isRequired,
  onReply: PropTypes.func.isRequired
}

export default Comment
