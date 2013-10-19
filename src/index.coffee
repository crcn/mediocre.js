Command = require "./message"
factory = require "./factory"
listenerCollection = require "./factory/collection"

class Mediator

  ###
  ###

  constructor: () ->
    @_listeners = {}

  ###
  ###

  on: (name, listeners...) ->
    nameParts = @_parse name

    unless @_listeners[nameParts.name]
      @_listeners[nameParts.name] = { pre: [], post: [] }

    # first map all the listeners, then wrap all the listeners in one function (collection)
    listeners = listenerCollection.create { mediator: @, options: listeners.map((listener) -> factory.create({ mediator: @, options: @})) }

    # pre / post hook?
    if nameParts.type
      collection = @_listeners nameParts.type
      collection.push listeners
    else
      @_listeners.callback = listeners


    # disposes the listener
    dispose: () ->
      if collection
        i = collection.indexOf listeners
      else
        delete @_listeners[nameParts.name]

  ###
  ###

  once: (name, listeners...) ->

    listeners.unshift (message, next) ->
      listener.dispose()
      next()

    listener = @on [name].concat(listeners)...

  ###
  ###

  execute: (nameOrMessage, data, next) ->

    unless nameOrMessage.__isCommand
      msg = new Message(nameOrMessage, data)
    else
      msg  = nameOrMessage
      next = data


    listener = @_listeners[cmd.name]

    if not listener or not listener.callback
      return next new Error "message '#{cmd.name}' doesn't exist"

    chain = listeners.pre.concat(listener.callback).concat(listeners.post)

    async.eachSeries chain, ((listener, next) ->
      listener msg, next
    ), (err) ->
      return next(err) if err?
      next null, msg.args...


  ###
  ###

  _parse: (message) ->
    messageParts = message.split " "
    name = messageParts.pop()
    type = messageParts.pop() # pre? post?

    { type: type, name: name }



module.exports = () -> new Mediator