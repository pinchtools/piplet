import React from 'react'
import { MuiThemeProvider, createMuiTheme } from 'material-ui/styles';
import createPalette from 'material-ui/styles/palette';
import primary from './../lib/miu/primary'
import accent from './../lib/miu/accent'
import error from './../lib/miu/error'

const theme = createMuiTheme({
  palette: createPalette({
    primary: primary, // Purple and green play nicely together.
    accent: accent,
    error: error,
  }),
})

const Theme = (props) => (
  <MuiThemeProvider theme={theme}>
    {props.children}
  </MuiThemeProvider>
)

export default Theme
