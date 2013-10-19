type = require "type-component"

module.exports = 
  test: (options) -> type(options.options) is "string"
  create: (options) ->

    mediator = options.mediator
    name     = options.options 

    (message, next) ->
      mediator.execute message.child(name), next