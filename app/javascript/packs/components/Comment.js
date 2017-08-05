import React from 'react'
import avatar from './../images/avatar.jpg'

const Comment = (props) => {
  return (
    <div className="comment">
      <div className="panel panel-default">
        <div className="panel-heading">
          <div className="pull-left">
            <img className="avatar" src={avatar}/>
          </div>
          <div className="pull-right">
            <i className="icon-like fa fa-heart-o" aria-hidden="true"></i>
          </div>
          <div>
            <div className="username"><a href="#">Pinchtools</a></div>
            <div className="date">5 minutes ago</div>
          </div>
        </div>
        <div className="panel-body">
          Panel content
        </div>
        <div className="panel-footer">
          <div className="pull-right">
            <a href="#"><small>reply</small></a>
            <a href="#" title="copy the link to the clipboard"><small>link</small></a>
            <i className="fa fa-chevron-down" aria-hidden="true"></i>
          </div>
          <div>
            <i className="highlight fa fa-bullhorn" aria-hidden="true"></i>

            <a href="#"><i className="fa fa-graduation-cap" aria-hidden="true"></i></a>
            <a href="#"><i className="fa fa-bullhorn" aria-hidden="true"></i></a>
            <a href="#"><i className="fa fa-thumbs-o-up" aria-hidden="true"></i></a>
            <a href="#"><i className="fa fa-lightbulb-o" aria-hidden="true"></i></a>
          </div>
        </div>
      </div>
      {props.children}
    </div>
  )
}

export default Comment
