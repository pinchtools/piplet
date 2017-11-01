const fs = require('fs')
const { sync } = require('glob')
const mkdirp = require('mkdirp')
const path = require('path')

const localeDir = './app/javascript/packs/locales/'
const buildDir = './app/javascript/build/'
const filePattern = `${buildDir}messages/**/*.json`
const localePattern = `${localeDir}*.json`

function AggregateTranslations() {
}

AggregateTranslations.prototype.apply = function(compiler) {
  compiler.plugin('emit', function (compilation, callback) {
    // Aggregates the default messages that were extracted from the example app's
    // React components via the React Intl Babel plugin. An error will be thrown if
    // there are messages in different components that use the same `id`. The result
    // is a flat collection of `id: message` pairs for the app's default locale.
    enMessages =  sync(filePattern)
      .map((filename) => fs.readFileSync(filename, 'utf8'))
      .map((file) => JSON.parse(file))
      .reduce((collection, descriptors) => {
        descriptors.forEach(({id, defaultMessage}) => {
          if (collection.hasOwnProperty(id)) {
            throw new Error(`Duplicate message id: ${id}`)
          }
          collection[id] = defaultMessage
        })
        return collection
      }, {})

    mkdirp.sync(buildDir)

    // Write the messages to this directory
    var jsonEn = JSON.stringify(enMessages, null, 2)
    fs.writeFileSync(localeDir + 'en.json', jsonEn)
    var jsonAll = {}

    //Merge all locales defined in packs/locales
    sync(localePattern).forEach(
      function(filename) {
        var ln = path.basename(filename, '.json')
        if (ln != 'en') {
          file = fs.readFileSync(filename, 'utf8')
          jsonAll[ln] =  JSON.parse(file)
        }
      }
    )

    fs.writeFileSync(buildDir + 'locales.json', JSON.stringify(jsonAll, null, 2))
    console.log('Aggregating translations JSON complete!')
    callback()
  })
}

module.exports = AggregateTranslations
