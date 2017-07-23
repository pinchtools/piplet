import React from 'react'
import PropTypes from 'prop-types'
import { withStyles, createStyleSheet } from 'material-ui/styles'
import Dialog, {withResponsiveFullScreen} from 'material-ui/Dialog'
import List, { ListItem, ListItemText } from 'material-ui/List'
import Divider from 'material-ui/Divider'
import AppBar from 'material-ui/AppBar'
import Toolbar from 'material-ui/Toolbar'
import IconButton from 'material-ui/IconButton'
import Typography from 'material-ui/Typography'
import CloseIcon from 'material-ui-icons/Close'
import Slide from 'material-ui/transitions/Slide'

const styleSheet = createStyleSheet('LoginDialog', {
  appBar: {
    position: 'relative',
  },
  flex: {
    flex: 1,
  },
})

const ResponsiveDialog = withResponsiveFullScreen({breakpoint: 'sm'})(Dialog)

const LoginDialog = ({ classes, loginProps, onLoginToggle }) => {
  return (
    <ResponsiveDialog
      open={loginProps.open}
      onRequestClose={onLoginToggle}
      transition={<Slide direction="up" />}
    >
      <AppBar className={classes.appBar}>
        <Toolbar>
          <Typography type="title" color="inherit" className={classes.flex}>
            Login
          </Typography>
          <IconButton color="contrast" onClick={onLoginToggle} aria-label="Close">
            <CloseIcon />
          </IconButton>
        </Toolbar>
      </AppBar>
      <List>
        <ListItem button>
          <ListItemText primary="Phone ringtone" secondary="Titania" />
        </ListItem>
        <Divider />
        <ListItem button>
          <ListItemText primary="Default notification ringtone" secondary="Tethys" />
        </ListItem>
      </List>
    </ResponsiveDialog>
  )
}

LoginDialog.propTypes = {
  classes: PropTypes.object.isRequired,
  loginProps: PropTypes.shape({
    open: PropTypes.bool.isRequired
  }).isRequired,
  onLoginToggle: PropTypes.func.isRequired
}

export default withStyles(styleSheet)(LoginDialog)
