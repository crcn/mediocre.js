Message            = require "./message"
factory            = require "./factory"
listenerCollection = require "./factory/collection"
type               = require "type-component"
async              = require "async"


class Mediator

  ###
  ###

  constructor: () ->
    @_listeners = {}


  ###
  ###

  on: (nameOrPlugin, listeners...) ->

    # might be a plugin for other listeners
    if nameOrPlugin.test
      return factory.push nameOrPlugin

    nameParts = @_parse nameOrPlugin

    unless listener = @_listeners[nameParts.name]
      listener = @_listeners[nameParts.name] = { pre: [], post: [] }

    # first map all the listeners, then wrap all the listeners in one function (collection)
    listeners = factory.create @, listeners

    # pre / post hook?
    if nameParts.type
      collection = listener[nameParts.type]
      collection.push listeners
    else
      listener.callback = listeners


    # disposes the listener
    dispose: () ->
      if collection
        i = collection.indexOf listeners
      else
        delete @_listeners[nameParts.name]

  ###
  ###

  message: (name, data, options = {}) -> new Message name, data, options, @

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
      msg = @message(nameOrMessage, data)
    else
      msg  = nameOrMessage
      next = data


    if arguments.length is 2 and type(data) is "function"
      next = data


    if type(next) isnt "function"
      next = () ->

    listener = @_listeners[msg.name] or {}


    chain = (listener.pre || []).concat(listener.callback || []).concat(listener.post || [])
      

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
    t = messageParts.pop() # pre? post?

    { type: t, name: name }



module.exports = () -> new Mediator