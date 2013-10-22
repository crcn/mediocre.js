

factories = [
  require("./obj"),
  require("./fn"),
  require("./ref"),
  collection = require("./collection")
]

module.exports = 

  push   : (factory) -> 
    factories.push factory

  create : (mediator, listeners) ->

    tlisteners = []

    for listener in listeners

      options = { mediator: mediator, listener: listener }

      for tester in factories
        if tester.test options
          tlisteners = tlisteners.concat tester.create options

    if tlisteners.length is 1
      return tlisteners[0]

    return collection.create { mediator: mediator, listener: tlisteners }


