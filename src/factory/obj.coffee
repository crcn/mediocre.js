type  = require "type-component"
async = require "async"

module.exports = 
  test   : (options) -> type(options.options) is "object"
  create : (options) ->

    names = Object.keys(options.options)
    mediator = options.mediator

    (message, next) -> 
      async.eachSeries names, ((name, next) ->
        mediator.execute(name, names.child(name), next)
      ), next
