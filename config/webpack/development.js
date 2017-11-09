// Note: You must restart bin/webpack-dev-server for changes to take effect
const environment = require('./environment')
const webpack = require('webpack')
const path = require("path")
const AggregateTranslations = require('./../../app/javascript/modules/AggregateTranslations.js')

// Get a pre-configured plugin
environment.plugins.get('ExtractText') // Is an ExtractTextPlugin instance

// Add an additional plugin of your choosing : ProvidePlugin
environment.plugins.set('AggregateTranslations', new AggregateTranslations())
environment.plugins.set(
  'WatchIgnorePlugin',
  new webpack.WatchIgnorePlugin([
    path.resolve(__dirname, '../../app/javascript/build/locales.json'),
    path.resolve(__dirname, '../../app/javascript/packs/locales/en.json'),
  ])
)

module.exports = environment

module.exports = environment.toWebpackConfig()
