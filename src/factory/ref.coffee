type = require "type-component"

module.exports = 
  test: (options) -> type(options.listener) is "string"
  create: (options) ->

    mediator = options.mediator
    ref      = options.listener 

    (message, next) ->
      mediator.execute message.child(ref), next