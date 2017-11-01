import object from 'lodash/object'

export default class ValidationErrors {
  errors = {}

  constructor(metaError) {
    if (metaError && metaError.data) {
      this.formatErrors(metaError.data.errors)
    }
  }

  label(source) {
    if (!source) return ''
    let attr = this.attribute(source)
    if (attr == 'base') return ''
    return attr.split('/').pop() + ' '
  }

  attribute(source) {
    return source.pointer.split('/').pop()
  }

  formatErrors(errors) {
    errors.map(function(e) {
      let attr = this.attribute(e.source)
      this.errors[attr] = this.label(e.source) + e.detail
    }, this)
  }

  attributes() {
    return object.keys(this.errors)
  }

  messages() {
    return object.values(this.errors)
  }

  empty() {
      return this.messages().length == 0
  }

  contains(key) {
    return this.attributes().indexOf(key) != -1
  }
}
