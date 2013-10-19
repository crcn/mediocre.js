type = require "type-component"

module.exports = 
  test: (options) -> type(options.options) is "fn"
  create: (options) -> 

    fn = options.options

    (message, next) ->
      fn message, (err, args...) ->
        return next(err) if err?
        if args.length
          message.args = args
        next()
