// Note: You must restart bin/webpack-dev-server for changes to take effect

const merge = require('webpack-merge')
const sharedConfig = require('./shared.js')
const { settings, output } = require('./configuration.js')
const path = require("path")
const { WatchIgnorePlugin } = require("webpack")
const AggregateTranslations = require('./../../app/javascript/modules/AggregateTranslations.js')

module.exports = merge(sharedConfig, {
  devtool: 'cheap-eval-source-map',

  stats: {
    errorDetails: true
  },

  output: {
    pathinfo: true
  },

  plugins: [
    new AggregateTranslations(),
    new WatchIgnorePlugin([
      path.resolve(__dirname, '../../app/javascript/build/locales.json'),
      path.resolve(__dirname, '../../app/javascript/packs/locales/en.json'),
    ]),
  ],

  devServer: {
    clientLogLevel: 'none',
    https: settings.dev_server.https,
    host: settings.dev_server.host,
    port: settings.dev_server.port,
    contentBase: output.path,
    publicPath: output.publicPath,
    compress: true,
    headers: { 'Access-Control-Allow-Origin': '*' },
    historyApiFallback: true,
    watchOptions: {
      ignored: /node_modules/
    }
  }
})
