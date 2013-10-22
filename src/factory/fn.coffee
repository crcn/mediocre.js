type = require "type-component"

module.exports = 
  test: (options) -> type(options.listener) is "function"
  create: (options) -> 

    fn = options.listener

    (message, next) ->
      fn message, (err, args...) ->
        return next(err) if err?
        if args.length
          message.root.args = args
        next()
