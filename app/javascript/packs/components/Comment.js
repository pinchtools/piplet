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
            eze<br/>ez
          </div>
        </div>
        <div className="panel-body">
          Panel content
        </div>
        <div className="panel-footer">
          <i className="icon-like highlight fa fa-bullhorn" aria-hidden="true"></i>
          <i className="icon-like fa fa-graduation-cap" aria-hidden="true"></i>
          <i className="icon-like fa fa-bullhorn" aria-hidden="true"></i>
          <i className="icon-like fa fa-thumbs-o-up" aria-hidden="true"></i>
          <i className="icon-like fa fa-lightbulb-o" aria-hidden="true"></i>
        </div>
      </div>
      {props.children}
    </div>
  )
}

export default Comment
