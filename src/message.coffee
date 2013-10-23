class Message

  ###
  ###

  __isCommand: true

  ###
  ###

  constructor: (@name, @data, @options = {}, @mediator, @parent = undefined) ->
    @args = []
    @root = if @parent then @parent.root else @

  ###
  ###

  child: (name, options) -> new Message name, @data, options, @mediator, @



module.exports = Message