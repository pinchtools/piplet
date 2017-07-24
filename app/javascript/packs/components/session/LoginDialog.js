import React from 'react'
import PropTypes from 'prop-types'
import {FormattedMessage} from 'react-intl'
import { withStyles, createStyleSheet } from 'material-ui/styles'
import Dialog, {withResponsiveFullScreen} from 'material-ui/Dialog'
import Grid from 'material-ui/Grid'
import Input from 'material-ui/Input'
import InputLabel from 'material-ui/Input/InputLabel'
import FormControl from 'material-ui/Form/FormControl'
import AppBar from 'material-ui/AppBar'
import Toolbar from 'material-ui/Toolbar'
import Button from 'material-ui/Button'
import IconButton from 'material-ui/IconButton'
import Typography from 'material-ui/Typography'
import CloseIcon from 'material-ui-icons/Close'
import Slide from 'material-ui/transitions/Slide'


const styleSheet = createStyleSheet('LoginDialog', theme => ({
  appBar: {
    position: 'relative',
  },
  flex: {
    flex: 1,
  },
  body: {
    padding: 10
  }
}))

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
      <Grid container gutter={24} className={classes.body}>
        <Grid item xs={12}>
          <FormControl  fullWidth>
            <InputLabel htmlFor="username">
              <FormattedMessage
                id="LoginDialog.username"
                defaultMessage={`username`}
              />
            </InputLabel>
            <Input id="username" />
          </FormControl>
        </Grid>
        <Grid item xs={12}>
          <FormControl fullWidth>
            <InputLabel htmlFor="password">
              <FormattedMessage
                id="LoginDialog.password"
                defaultMessage={`password`}
              />
            </InputLabel>
            <Input id="password" type="password" />
          </FormControl>
        </Grid>
        <Grid item xs={12}>
          <Grid container justify="flex-end">
            <Grid item >
              <Button onClick={() => onLoginToggle()}>
                <FormattedMessage
                  id="LoginDialog.cancel"
                  defaultMessage={`cancel`}
                />
              </Button>
            </Grid>
            <Grid item >
              <Button raised color='accent' onClick={() => onLoginToggle()}>
                <FormattedMessage
                  id="LoginDialog.submit"
                  defaultMessage={`submit`}
                />
              </Button>
            </Grid>
          </Grid>
        </Grid>
      </Grid>
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
