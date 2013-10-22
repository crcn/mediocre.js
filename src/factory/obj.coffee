type  = require "type-component"
async = require "async"

module.exports = 
  test   : (options) -> type(options.listener) is "object"
  create : (options) ->

    refs     = Object.keys(options.listener)
    mediator = options.mediator

    (message, next) ->
      async.eachSeries refs, ((ref, next) ->
        mediator.execute(message.child(ref, options.listener[ref]), next)
      ), next
