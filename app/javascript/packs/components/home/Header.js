import React from 'react'
import PropTypes from 'prop-types'
import { withStyles, createStyleSheet } from 'material-ui/styles'
import Button from 'material-ui/Button'
import Divider from 'material-ui/Divider'
import Grid from 'material-ui/Grid'
import Typography from 'material-ui/Typography'
import {FormattedMessage} from 'react-intl'

const styleSheet = createStyleSheet('Header', theme => ({
  root: {
    flexGrow: 1
  },
  container: {
    padding: 10
  }
}));


const Header = ({ classes, onLoginToggle }) => {
  return (
    <div className={classes.root}>
      <Grid container gutter={8}  className={classes.container} align="center">
        <Grid item xs={8}>
          <Typography type="subheading">
            84 comments
          </Typography>
        </Grid>
        <Grid item xs={4}>
          <Grid container justify="flex-end">
            <Grid item>
              <Button raised color='accent' onClick={() => onLoginToggle()}>
                <FormattedMessage
                  id="Header.login"
                  defaultMessage={`login`}
                />
              </Button>
            </Grid>
          </Grid>
        </Grid>
      </Grid>
      <Divider light/>
    </div>
  )
}


Header.propTypes = {
  classes: PropTypes.object.isRequired,
  onLoginToggle: PropTypes.func.isRequired
}

export default withStyles(styleSheet)(Header)
