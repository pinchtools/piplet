import { connect } from 'react-redux'
import { replyComment } from './actions'
import CommentComp from  './component'

const mapStateToProps = (state, props) => {
  return {
    comment: state.comments[props.id]
  }
}

const mapDispatchToProps = dispatch => {
  return {
    onReply: (id) => {
      dispatch(replyComment(id))
    }
  }
}

const Comment = connect(
  mapStateToProps,
  mapDispatchToProps
)(CommentComp)

export default Comment
