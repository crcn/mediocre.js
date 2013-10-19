type  = require "type-component"
async = require "async"

module.exports = 
  test: (options) -> type(options.options) is "array"
  create: (options) ->

    if options.options.length is 1
      return options.options[0]

    (message, next) ->
      async.eachSeries options.options, ((listener, next) =>
        listener.call @, message, next
      ), next



