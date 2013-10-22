class Message

  ###
  ###

  __isCommand: true

  ###
  ###

  constructor: (@name, @data, @options = {}, @parent = undefined) ->
    @args = []

  ###
  ###

  child: (name, options) -> new Message name, @data, options, @


module.exports = Message