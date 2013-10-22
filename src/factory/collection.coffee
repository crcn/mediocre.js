type  = require "type-component"
async = require "async"

module.exports = 
  test: (options) -> type(options.listener) is "array"
  create: (options) ->

    if options.listener.length is 1
      return options.listener[0]

    (message, next) ->
      async.eachSeries options.listener, ((listener, next) =>
        listener.call @, message, next
      ), next



